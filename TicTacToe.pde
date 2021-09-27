import java.util.Arrays;

int speed, n;
float[] padding;
color background = color(0, 209, 255);

Board board;
RLAgent ai;
Fool fool;
Environment env;

enum Player {
  HUMAN, FOOL, AI
};
Selector<Player> s1, s2;
int n_humans;

String debugText;

void setup() {
  size(700, 700);
  background(0, 209, 255);

  padding = new float[]{100, 50, 50, 50};
  speed = 1000;

  n = 3;
  env = new Environment();
  fool = new Fool(n*n);
  ai = new RLAgent(env);
  ai.specialRewards = new ArrayList<Float>(Arrays.asList(100f, -100f));

  s1 = new Selector<Player>(padding[3], 10, 200, 80);
  s1.set(Player.values());
  s1.rectMode = CORNER;
  s1.borderRadius = 40;

  s2 = new Selector<Player>(width-padding[1]-200, 10, 200, 80);
  s2.set(Player.values());
  s2.rectMode = CORNER;
  s2.borderRadius = 40;

  resetBoardAndAI();
  /*
            action = agent.react(state)
            new_state,reward,done,info = env.step(action)
            agent.update(state,action,new_state,reward,done)
            if show: print(info)
            state = new_state
            total_reward += reward
        if show: env.render()
        episode_rewards['rewards'].append(total_reward)
        if episode % STATS_EVERY == 0:
            
  */
  debugText = "";
}

void resetBoardAndAI() {
  board = new Board(n, n);
  if (s1.getValue() == Player.AI) {
    ai.player = "X";
  } else if (s2.getValue() == Player.AI) {
    ai.player = "O";
  }
}

void draw() {
  background(background);
  int tempSpeed = n_humans()==0?speed:1;
  for (int i=0; i<tempSpeed; i++) {
    //    debugText = "";
    ui.update();

    Player player;
    if (board.player.equals("X")) {
      player = s1.getValue();
    } else {
      player = s2.getValue();
    }

    String winner = board.win.winStr;

    if (player == Player.AI || winner.equals(ai.player)) {
      train(winner);
    } else if (player == Player.FOOL) {
      int action = fool.react();
      board.update(action);
    } else {
      board.update();
    }
    s1.update();
    s2.update();
    if (s1.isTouched() || s2.isTouched()) {
      resetBoardAndAI();
    }
  }

  board.display();
  s1.display();
  s2.display();
  showScore();
  fill(0);
  text(debugText, width/2, height/2);
}

void train(String winner) {
  String state = board.getState();
  int action = ai.react(state);
  board.update(action);
  
  String newState = board.getState();

  float reward;
  if (winner.equals(" ")) {
    reward = 0;
  } else {
    if (winner.equals(ai.player)) {
      reward = 100;
    } else {
      reward = -100;
    }
  }
  ai.update(state, action, newState, reward);
  env.addReward(winner,reward);
}

void showScore() {
  textSize(padding[0]/3);
  text("X - "+String.valueOf(board.scoreX), 
    width/2, padding[0]/6);
  text("O - "+String.valueOf(board.scoreO), 
    width/2, 3*padding[0]/6);
  text("D - "+String.valueOf(board.scoreD), 
    width/2, 5*padding[0]/6);
}

int n_humans() {
  n_humans = 0;
  if (s1.getValue() == Player.HUMAN) {
    n_humans ++;
  }
  if (s2.getValue() == Player.HUMAN) {
    n_humans ++;
  }
  return n_humans;
}

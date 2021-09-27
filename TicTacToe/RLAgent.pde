//import java.utils.Map;

class RLAgent {
  Environment env;
  HashMap<String,QValues> qtable;
  int n;
  float min,max;
  ArrayList<Float> specialRewards;
  float learningRate,discount;
  String player;

  RLAgent(Environment _env) {
    this.env = _env;
    this.n = env.actionSpace;
    this.min = -0.5;
    this.max = 0.5;
    qtable = new HashMap<String,QValues>();
    specialRewards = new ArrayList<Float>();
    learningRate = 0.1;
    discount = 0.95;
  }
  
  int react(String state) {
    if (!qtable.containsKey(state)) {
      qtable.put(state,new QValues(n,min,max));
    }
    return qtable.get(state).argmax();
  }
  
  void update(String state,int action,String newState, float reward) {
    float newQ;
    if (specialRewards.contains(reward)) {
      newQ = reward;
    } else if (state.equals(newState)) {
      newQ = -100;
    } else {
      float currentQ = qtable.get(state).get(action);
//      debugText = String.valueOf(currentQ);
      if (!qtable.containsKey(newState)) {
        qtable.put(newState,new QValues(n,min,max));
      }
      float maxFutureQ = qtable.get(newState).qMax();
//      debugText += ","+String.valueOf(maxFutureQ);
      newQ = (1-learningRate)*currentQ +
             learningRate*(reward + discount*maxFutureQ);
//      debugText += state;
//      debugText += String.valueOf(action);
//      debugText += String.valueOf(currentQ);
//      debugText += String.valueOf(newQ);
    }
    
//    debugText += ","+String.valueOf(newQ);
    qtable.get(state).set(action,newQ);
  }
}

class State {
  
}

class QValues {
  float[] qvalues;
  QValues(int n,float min, float max) {
    this.qvalues = new float[n];
    for (int i=0;i<n;i++) {
      qvalues[i] = random(min,max);
    }
  }
  float get(int i) {
    return qvalues[i];
  }
  void set(int i,float f) {
    qvalues[i] = f;
  }
  float qMax() {
    return max(qvalues);
  }
  int argmax() {
    return index(qMax());
  }
  int index(float value) {
    for (int i=0;i<qvalues.length;i++) {
      if (qvalues[i] == value) {
        return i;
      }
    }
    return -1;
  }
}
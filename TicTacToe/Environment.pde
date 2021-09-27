import java.util.Collections;
import java.util.List;

class Environment {
  ArrayList<Float> rewards;
  ArrayList<Float> min;
  ArrayList<Float> max;
  ArrayList<Float> avg;
  float totalReward;
  int actionSpace, episode, statsEvery;

  Environment() {
    rewards = new ArrayList<Float>();
    min = new ArrayList<Float>();
    max = new ArrayList<Float>();
    avg = new ArrayList<Float>();
    totalReward = 0;
    actionSpace = 9;
    episode = 0;
    statsEvery = 10;
  }

  void addReward(String winner,float reward) {
    if (!winner.equals(" ")) {
      episode++;
      rewards.add(totalReward);
      totalReward = 0;
    }
    totalReward += reward;
    if (episode != 0 && episode % statsEvery == 0) {
      List<Float> rewardWindow = rewards.subList(episode-statsEvery,episode);
      float sum = 0;
      for (float r : rewardWindow) {
        sum += r;
      }
      float avg = sum/statsEvery;
      float min = Collections.min(rewardWindow);
      float max = Collections.max(rewardWindow);
      this.avg.add(avg);
      this.min.add(min);
      this.max.add(max);
      println("Episode:",episode,"avg:",avg,"min:",min,"max:",max);
    }
  }

}
/*

 avg = sum(reward_window)/len(reward_window)
 _min = min(reward_window)
 _max = max(reward_window)
 episode_rewards['avg'].append(avg)
 episode_rewards['min'].append(_min)
 episode_rewards['max'].append(_max)
 print(f"Episode: {episode},avg: {avg},min: {_min},max: {_max}")
 */
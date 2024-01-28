class Player{
  final String? nickname;
  final String? email;
  final int? money;
  final List<bool>? bought;
  final List<Map<String,dynamic>>? times;

  Player(this.nickname, this.email, this.money, this.bought, this.times);
  //print(player.money);
  Player get getPlayer => Player(nickname, email, money,bought, times);
  
}
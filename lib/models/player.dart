class Player{
  final String nickname;
  final String email;
  final int money;
  final List<bool> bought;
  final List<List<String>> times;
  final List<int> appcolorTheme;
  final List<int> bgcolorTheme;
  final String language;
  Player(this.nickname, this.email, this.money, this.bought, this.times, this.appcolorTheme, this.bgcolorTheme, this.language);
  Player get getPlayer => Player(nickname, email, money,bought, times, appcolorTheme, bgcolorTheme, language);
  
}
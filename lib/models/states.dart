class States{

  String stateid="";
  String statename="";


  States(String stateid,String statename){
    this.stateid=stateid;
    this.statename=statename;
  }


  @override
  String toString() {
    return statename.toLowerCase() + statename.toUpperCase();
  }



  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is States &&
              runtimeType == other.runtimeType &&
              stateid == other.stateid;

  @override
  int get hashCode => stateid.hashCode;




}
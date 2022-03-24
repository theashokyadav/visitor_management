class Country
{
  String countryid = "";
  String countryname = "";

  Country(String contryid, String countryname){
    this.countryid = countryid;
    this.countryname = countryname;
  }

  @override
  String toString() {
    return countryname.toLowerCase() + countryname.toUpperCase();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Country &&
              runtimeType == other.runtimeType &&
              countryid == other.countryid;

  @override
  int get hashCode => countryid.hashCode;

}
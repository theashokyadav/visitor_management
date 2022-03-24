class Company
{
String id = "";
String companyname = "";

Company(String id, String companyname){
  this.id = id;
  this.companyname = companyname;
}

@override
String toString() {
  return companyname.toLowerCase() + companyname.toUpperCase();
}

@override
bool operator ==(Object other) =>
    identical(this, other) ||
        other is Company &&
            runtimeType == other.runtimeType &&
            id == other.id;

@override
int get hashCode => id.hashCode;

}
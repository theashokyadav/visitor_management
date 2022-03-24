class Tag
{
  String tagid = "";
  String tagname = "";

  Tag(String tagid, String tagname){
    this.tagid = tagid;
    this.tagname = tagname;
  }

  @override
  String toString() {
    return tagname.toLowerCase() + tagname.toUpperCase();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Tag &&
              runtimeType == other.runtimeType &&
              tagid == other.tagid;

  @override
  int get hashCode => tagid.hashCode;

}
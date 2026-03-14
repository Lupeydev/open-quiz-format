{
  buildGoModule
}:

let
  name = "oqf";
  pname = "go";
  src = ./.;
  vendorHash = null;
in
buildGoModule {
  inherit name pname src vendorHash;
}

{ lib, fetchFromGitHub, buildGoModule, makeWrapper }:
buildGoModule {
  pname = "kuake_cli";
  version = "v1.3.7";
  src = fetchFromGitHub {
    owner = "zhangjingwei";
    repo = "kuake_cli";
    rev = "v1.3.7";
    sha256 = "sha256-OhiFqZ9zTXVnRqj1oR6DtaSke6PE+L+nWRTU/K/s5do=";
  };
  
  vendorHash = null;

  subPackages = [ "cmd" ];

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    if [ -f $out/bin/main ]; then
      mv $out/bin/main $out/bin/kuake
    elif [ -f $out/bin/cmd ]; then
      mv $out/bin/cmd $out/bin/kuake
    fi

    wrapProgram $out/bin/kuake \
      --add-flags "-c \$HOME/.config/kuake/config.json"
  '';

  meta = with lib; {
    description = "夸克网盘 CLI 工具";
    homepage = "https://github.com/zhangjingwei/kuake_cli";
    mainProgram = "kuake";
  };
}

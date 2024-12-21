#!/bin/sh
set -e

mitamae_version="1.14.2"
mitamae_linux_sha256="9087071eab88d4243639eb73b50c19277d00d614d46edacbd9febd6250515755"

mitamae_cache="mitamae-${mitamae_version}"
if ! [ -f "bin/${mitamae_cache}" ]; then
  case "$(uname)" in
    "Linux")
      mitamae_bin="mitamae-x86_64-linux"
      mitamae_sha256="$mitamae_linux_sha256"
      ;;
    *)
      echo "unexpected uname: $(uname)"
      exit 1
      ;;
  esac

  curl -o "bin/${mitamae_bin}.tar.gz" -fL "https://github.com/k0kubun/mitamae/releases/download/v${mitamae_version}/${mitamae_bin}.tar.gz"
  sha256="$(/usr/bin/openssl dgst -sha256 "bin/${mitamae_bin}.tar.gz" | cut -d" " -f2)"
  if [ "$mitamae_sha256" != "$sha256" ]; then
    printf "checksum verification failed!\nexpected: %s\n  actual: %s", "$mitamae_sha256", "$sha256"
    exit 1
  fi
  tar xvzf "bin/${mitamae_bin}.tar.gz"

  rm "bin/${mitamae_bin}.tar.gz"
  mv "${mitamae_bin}" "bin/${mitamae_cache}"
  chmod +x "bin/${mitamae_cache}"
fi
ln -sf "${mitamae_cache}" bin/mitamae

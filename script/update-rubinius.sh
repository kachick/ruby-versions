#!/bin/bash
# 2015 Kenichi Kamiya
# ref: https://gist.github.com/kachick/86dc08f746074a00ea0f
# Support to make patch for newer rbx on ruby-versions
# Target to Mac OS X
# ./this.sh 2.5.7

LANG=C; export LANG

if [ $# != 1 ]; then
  echo "usage: $0 version(ex: 2.5.7)" 1>&2
  exit 0
fi

function support_batch() {
  local -r version="$1"
  local -r bz2="https://github.com/rubinius/rubinius/releases/download/v${version}/rubinius-${version}.tar.bz2"
  local -r fname="rubinius-${version}.tar.bz2"

  cd /tmp
  curl -LO "$bz2"

  local -r md5=$(md5 -q "$fname")
  local -r sha1=$(shasum -a1 "$fname")
  local -r sha256=$(shasum -a256 "$fname")
  local -r sha512=$(shasum -a512 "$fname")

  cat <<EOD
rbx/checksums.md5
${md5}

rbx/checksums.sha1
${sha1}

rbx/checksums.sha256
${sha256}

rbx/checksums.sha512
${sha512}

rbx/stable.txt
${version}

rbx/versions.txt
${version}
EOD
}

support_batch "$1"

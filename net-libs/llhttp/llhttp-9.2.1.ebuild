# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P=llhttp-release-v${PV}
DESCRIPTION="Port of http_parser to llparse"
HOMEPAGE="https://github.com/nodejs/llhttp/"
# note the tag with generated release data is called "release/v${PV}"
# (while "v${PV}" is just snapshot of the unprocessed source repo)
SRC_URI="
	https://github.com/nodejs/llhttp/archive/release/v${PV}.tar.gz
		-> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 arm arm64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Pure golang package for reading and writing xz-compressed files"
HOMEPAGE="https://github.com/ulikunitz/xz"
SRC_URI="https://github.com/ulikunitz/xz/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/xz-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build ./cmd/gxz
}

src_test() {
	# TODO: Need to give it test data?
	ego test ./cmd/gxz
}

src_install() {
	dobin gxz
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Cryptographically sign and verify files"
HOMEPAGE="http://www.openbsd.org/ https://github.com/aperezdc/signify"
SRC_URI="https://github.com/aperezdc/signify/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-libs/libbsd-0.7"
DEPEND="${RDEPEND}"

src_configure() {
	tc-export CC
}

src_install() {
	DESTDIR="${D}" PREFIX="/usr" emake install
}

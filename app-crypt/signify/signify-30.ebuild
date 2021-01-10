# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Cryptographically sign and verify files"
HOMEPAGE="http://www.openbsd.org/ https://github.com/aperezdc/signify"
SRC_URI="https://github.com/aperezdc/signify/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-libs/libbsd-0.7"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-30-man_compress.patch )

src_configure() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" install
	einstalldocs
}

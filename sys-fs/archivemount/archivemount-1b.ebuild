# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit toolchain-funcs

MY_P="${PN}-ng-${PV}"
DESCRIPTION="Mount archives using libarchive and FUSE"
HOMEPAGE="https://git.sr.ht/~nabijaczleweli/archivemount-ng"
SRC_URI="https://git.sr.ht/~nabijaczleweli/archivemount-ng/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Tests require access to /dev/fuse.
RESTRICT="test"
PROPERTIES="test_privileged"

RDEPEND="
	app-arch/libarchive:=
	sys-fs/fuse:3=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		SOURCE_DATE_EPOCH=$(stat -c %Y archivemount.1.in) \
		VERSION="${PV}"
}

src_install() {
	emake install \
		PREFIX="${EPREFIX}/usr" \
		DESTDIR="${D}"
}

src_test() {
	addwrite /dev/fuse
	default
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}_${PV}"
DESCRIPTION="Interconverts between various bibliography formats using common XML intermediate"
HOMEPAGE="https://sourceforge.net/p/bibutils/home/Bibutils/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}_src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -ie 's/REPLACE_INSTALLDIR/${DESTDIR}&/' Makefile_start || die
	sed -ie 's/REPLACE_LIBINSTALLDIR/${DESTDIR}&/' Makefile_start || die
}

src_configure() {
	./configure \
		--install-dir /usr/bin \
		--install-lib /usr/$(get_libdir) \
		--dynamic || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		DISTRO_CFLAGS="${CFLAGS}" \
		LDFLAGSIN="${LDFLAGS}"
}

src_test() {
	emake \
		CC="$(tc-getCC)" \
		DISTRO_CFLAGS="${CFLAGS}" \
		LDFLAGSIN="${LDFLAGS}" test
}

src_install() {
	emake DESTDIR="${ED}" install
}

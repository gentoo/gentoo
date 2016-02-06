# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools toolchain-funcs

PATCH_LEVEL=14
MY_P="${PN}_${PV}"

DESCRIPTION="Utility for opening arj archives"
HOMEPAGE="http://arj.sourceforge.net"
SRC_URI="mirror://debian/pool/main/a/arj/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/a/arj/${MY_P}-${PATCH_LEVEL}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-implicit-declarations.patch"
	"${FILESDIR}/${P}-glibc2.10.patch"
	"${WORKDIR}"/debian/patches/
	"${FILESDIR}/${P}-darwin.patch"
	"${FILESDIR}/${P}-interix.patch"
)

src_prepare() {
	default
	cd gnu || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	cd gnu || die
	CFLAGS="${CFLAGS} -Wall" econf
}

src_compile() {
	sed -i -e '/stripgcc/d' GNUmakefile || die

	ARJLIBDIR="${EPREFIX}/usr/$(get_libdir)"
	emake CC=$(tc-getCC) libdir="${ARJLIBDIR}" \
		ADD_LDFLAGS="${LDFLAGS}" \
		pkglibdir="${ARJLIBDIR}" all
}

src_install() {
	emake pkglibdir="${ARJLIBDIR}" DESTDIR="${D}" install
	dodoc doc/rev_hist.txt
}

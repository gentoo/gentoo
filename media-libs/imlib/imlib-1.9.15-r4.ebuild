# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils multilib-minimal

PVP=(${PV//[-\._]/ })
DESCRIPTION="Image loading and rendering library"
HOMEPAGE="http://ftp.acc.umu.se/pub/GNOME/sources/imlib/1.9/"
SRC_URI="mirror://gnome/sources/${PN}/${PVP[0]}.${PVP[1]}/${P}.tar.bz2
	mirror://gentoo/gtk-1-for-imlib.m4.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="doc static-libs"

RDEPEND=">=media-libs/tiff-3.9.7-r1[${MULTILIB_USEDEP}]
	>=media-libs/giflib-4.1.6-r3[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.2.51[${MULTILIB_USEDEP}]
	>=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}]
	>=x11-libs/libICE-1.0.8-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libSM-1.2.1-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	abi_x86_32? (
		!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
		!<=app-emulation/emul-linux-x86-gtklibs-20140406
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	# Fix aclocal underquoted definition warnings.
	# Conditionalize gdk functions for bug 40453.
	# Fix imlib-config for bug 3425.
	epatch "${FILESDIR}"/${P}.patch
	epatch "${FILESDIR}"/${PN}-security.patch #security #72681
	epatch "${FILESDIR}"/${P}-bpp16-CVE-2007-3568.patch # security #201887
	epatch "${FILESDIR}"/${P}-fix-rendering.patch #197489
	epatch "${FILESDIR}"/${P}-asneeded.patch #207638
	epatch "${FILESDIR}"/${P}-libpng15.patch #357167
	epatch "${FILESDIR}"/${P}-underlinking-test.patch #367645
	epatch "${FILESDIR}"/${P}-no-LDFLAGS-in-pc.patch

	mkdir m4 && cp "${WORKDIR}"/gtk-1-for-imlib.m4 m4

	AT_M4DIR="m4" eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--sysconfdir=/etc/imlib \
		$(use_enable static-libs static) \
		--disable-gdk \
		--disable-gtktest
}

multilib_src_install() {
	emake DESTDIR="${D}" install || die
}

multilib_src_install_all() {
	dodoc AUTHORS ChangeLog README
	use doc && dohtml doc/*

	# Punt unused files
	rm -f "${D}"/usr/lib*/pkgconfig/imlibgdk.pc
	find "${D}" -name '*.la' -exec rm -f {} +
}

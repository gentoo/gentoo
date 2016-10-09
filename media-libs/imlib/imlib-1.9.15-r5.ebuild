# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools multilib-minimal

PVP=(${PV//[-\._]/ })
DESCRIPTION="Image loading and rendering library"
HOMEPAGE="http://ftp.acc.umu.se/pub/GNOME/sources/imlib/1.9/"
SRC_URI="mirror://gnome/sources/${PN}/${PVP[0]}.${PVP[1]}/${P}.tar.bz2
	mirror://gentoo/gtk-1-for-imlib.m4.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc static-libs"

RDEPEND="
	>=media-libs/tiff-3.9.7-r1:0[${MULTILIB_USEDEP}]
	>=media-libs/giflib-5.1:0=[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.2.51:0=[${MULTILIB_USEDEP}]
	>=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}]
	>=x11-libs/libICE-1.0.8-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libSM-1.2.1-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# Fix aclocal underquoted definition warnings.
	# Conditionalize gdk functions for bug 40453.
	# Fix imlib-config for bug 3425.
	eapply "${FILESDIR}"/${P}.patch
	eapply "${FILESDIR}"/${PN}-security.patch #security #72681
	eapply "${FILESDIR}"/${P}-bpp16-CVE-2007-3568.patch # security #201887
	eapply "${FILESDIR}"/${P}-fix-rendering.patch #197489
	eapply "${FILESDIR}"/${P}-asneeded.patch #207638
	eapply "${FILESDIR}"/${P}-libpng15.patch #357167
	eapply "${FILESDIR}"/${P}-underlinking-test.patch #367645
	eapply "${FILESDIR}"/${P}-no-LDFLAGS-in-pc.patch
	eapply "${FILESDIR}"/${P}-giflib51-{1,2}.patch #538976

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
	emake DESTDIR="${D}" install
	# fix target=@gdk-target@ in pkgconfig, bug #499268
	sed -e '/^target=/d' \
		-i "${ED}"usr/$(get_libdir)/pkgconfig/imlib.pc || die
}

multilib_src_install_all() {
	einstalldocs
	use doc && dohtml doc/*

	# Punt unused files
	rm -f "${D}"/usr/lib*/pkgconfig/imlibgdk.pc
	find "${D}" -name '*.la' -exec rm -f {} + || die
}

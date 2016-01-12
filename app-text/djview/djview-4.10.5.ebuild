# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools gnome2-utils fdo-mime flag-o-matic versionator toolchain-funcs multilib nsplugins

DESCRIPTION="Portable DjVu viewer using Qt4"
HOMEPAGE="http://djvu.sourceforge.net/djview4.html"
SRC_URI="mirror://sourceforge/djvu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug nsplugin"

RDEPEND="
	>=app-text/djvu-3.5.22-r1
	dev-qt/qtdbus:4
	dev-qt/qtopengl:4
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.67
	virtual/pkgconfig
	nsplugin? ( dev-libs/glib:2 )"

src_prepare() {
	# Force XEmbed instead of Xt-based mainloop (disable Xt autodep)
	sed -e 's:\(ac_xt=\)yes:\1no:' -i configure* || die
	sed 's/AC_CXX_OPTIMIZE/OPTS=;AC_SUBST(OPTS)/' -i configure.ac || die #263688
	rm aclocal.m4 config/{libtool.m4,install-sh,ltmain.sh,lt*.m4}
	AT_M4DIR="config" eautoreconf
}

src_configure() {
	# See config/acinclude.m4
	use debug || append-cppflags "-DNDEBUG"

	# QTDIR is needed because of kde3
	QTDIR=/usr \
	econf \
		--with-x \
		$(use_enable nsplugin nsdejavu) \
		--disable-desktopfiles
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

src_install() {
	emake DESTDIR="${D}" \
		plugindir=/usr/$(get_libdir)/${PLUGINS_DIR} \
			install

	dodoc README NEWS

	cd desktopfiles
	insinto /usr/share/icons/hicolor/32x32/apps
	newins prebuilt-hi32-djview4.png djvulibre-djview4.png
	insinto /usr/share/icons/hicolor/64x64/apps
	newins prebuilt-hi64-djview4.png djvulibre-djview4.png
	insinto /usr/share/icons/hicolor/scalable/apps
	newins djview.svg djvulibre-djview4.svg
	sed -i -e 's/Exec=djview4/Exec=djview/' djvulibre-djview4.desktop
	domenu djvulibre-djview4.desktop
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

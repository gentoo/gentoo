# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic nsplugins qmake-utils toolchain-funcs xdg-utils

DESCRIPTION="Portable DjVu viewer using Qt"
HOMEPAGE="http://djvu.sourceforge.net/djview4.html"
SRC_URI="mirror://sourceforge/djvu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"
IUSE="debug nsplugin"

RDEPEND="
	>=app-text/djvu-3.5.22-r1
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	>=sys-devel/autoconf-2.67
	virtual/pkgconfig
	nsplugin? ( dev-libs/glib:2 )"

DOCS=( README NEWS )

PATCHES=( "${FILESDIR}/${P}-hidpi.patch" )

src_prepare() {
	default

	# Force XEmbed instead of Xt-based mainloop (disable Xt autodep)
	sed -e 's:\(ac_xt=\)yes:\1no:' -i configure* || die
	sed 's/AC_CXX_OPTIMIZE/OPTS=;AC_SUBST(OPTS)/' -i configure.ac || die #263688
	rm aclocal.m4 config/{libtool.m4,install-sh,ltmain.sh,lt*.m4} || die
	AT_M4DIR="config" eautoreconf
}

src_configure() {
	# See config/acinclude.m4
	use debug || append-cppflags "-DNDEBUG"

	QTDIR=$(qt5_get_libdir)/qt5 \
	econf \
		--with-x \
		--disable-desktopfiles \
		$(use_enable nsplugin nsdejavu)
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

src_install() {
	emake DESTDIR="${D}" \
		plugindir=/usr/$(get_libdir)/${PLUGINS_DIR} \
			install

	einstalldocs

	insinto /usr/share/icons/hicolor/32x32/apps
	newins desktopfiles/prebuilt-hi32-djview4.png djvulibre-djview4.png
	insinto /usr/share/icons/hicolor/64x64/apps
	newins desktopfiles/prebuilt-hi64-djview4.png djvulibre-djview4.png
	insinto /usr/share/icons/hicolor/scalable/apps
	newins desktopfiles/djview.svg djvulibre-djview4.svg
	sed -e 's/Exec=djview4/Exec=djview/' \
		-i desktopfiles/djvulibre-djview4.desktop || die
	domenu desktopfiles/djvulibre-djview4.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

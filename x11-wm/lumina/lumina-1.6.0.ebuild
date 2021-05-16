# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="af ar az bg bn bs ca cs cy da de el en_AU en_GB en_ZA es et eu fa fi fr fr_CA fur gl he hi hr hu id is it ja ka ko lt lv mk mn ms mt nb ne nl pa pl pt pt_BR ro ru sa sk sl sr sv sw ta tg th tr uk ur uz vi zh_CN zh_HK zh_TW zu"
inherit qmake-utils l10n xdg-utils

DESCRIPTION="Lumina desktop environment"
HOMEPAGE="https://lumina-desktop.org/"
SRC_URI="https://github.com/trueos/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="desktop-utils"

DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libxcb:0
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-wm
	desktop-utils? ( app-text/poppler[qt5] )"

RDEPEND="${DEPEND}
	app-admin/sysstat
	media-sound/alsa-utils
	sys-fs/inotify-tools
	sys-power/acpi
	|| (
		x11-apps/xbacklight
		sys-power/acpilight
	)
	x11-misc/numlockx
	x11-wm/fluxbox"

BDEPEND="
	dev-qt/linguist-tools:5"

S="${WORKDIR}/${P/_/-}"

PATCHES=(
	"${FILESDIR}/1.2.0-desktop-files.patch"
)

DOCS=( README.md )

src_prepare() {
	default

	if ! use desktop-utils ; then
		rm -rf src-qt5/desktop-utils || die
		sed -e "/desktop-utils/d" -i src-qt5/src-qt5.pro || die
	fi

	l10n_find_plocales_changes "${S}/src-qt5/core/${PN}-desktop/i18n" "${PN}-desktop_" '.ts'
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr" LIBPREFIX="${EPREFIX}/usr/$(get_libdir)" \
		CONFIG+=WITH_I18N QMAKE_CFLAGS_ISYSTEM=
}

src_install() {
	emake install INSTALL_ROOT="${D}"
	einstalldocs
	mkdir -p "${D}"/usr/share/icons/hicolor/64x64/apps || die "cannot create the icons dir"
	mv "${D}"/usr/share/icons/hicolor/scalable/apps/*.png "${D}"/usr/share/icons/hicolor/64x64/apps || die "cannot mv png icons"
	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}/lumina-session" lumina ||die

	remove_locale() {
		rm -f "${ED}"/usr/share/${PN}-desktop/i18n/l*_${1}.qm

	}
	l10n_for_each_disabled_locale_do remove_locale
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

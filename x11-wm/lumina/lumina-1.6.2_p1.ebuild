# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="af ar az bg bn bs ca cs cy da de el en_AU en_GB en_ZA es et eu fa fi fr fr_CA fur gl he hi hr hu id is it ja ka ko lt lv mk mn ms mt nb ne nl pa pl pt pt_BR ro ru sa sk sl sr sv sw ta tg th tr uk ur uz vi zh_CN zh_HK zh_TW zu"
inherit plocale cmake xdg optfeature

DESCRIPTION="Lumina desktop environment"
HOMEPAGE="https://lumina-desktop.org/ https://github.com/lumina-desktop/lumina"
COMMIT="a521c780862034bf2cd18fc0b258c0541def6dc5"
SRC_URI="https://github.com/andreygrozin/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-wm
	desktop-utils? ( app-text/poppler[qt5] )"

RDEPEND="${DEPEND}
	app-admin/sysstat
	media-sound/alsa-utils
	sys-apps/dbus
	sys-fs/inotify-tools
	sys-power/acpi
	|| (
		x11-apps/xbacklight
		sys-power/acpilight
	)
	x11-apps/xinit
	x11-apps/xrandr
	x11-misc/numlockx
	x11-misc/xcompmgr
	x11-wm/fluxbox"

BDEPEND="
	dev-qt/linguist-tools:5
	dev-qt/qtpaths:5"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=( -DUtils=$(usex desktop-utils) )
	cmake_src_configure
	plocale_find_changes "${S}/src-qt5/core/${PN}-desktop/i18n" "${PN}-desktop_" '.ts'
}

src_install() {
	cmake_src_install
	einstalldocs

	remove_locale() {
		rm -f "${ED}"/usr/share/${PN}-desktop/i18n/l*_${1}.qm
	}

	plocale_for_each_disabled_locale remove_locale
}

pkg_postinst() {
	optfeature_header "Additional runtime features:"
	optfeature "screensaver support" x11-misc/xscreensaver
}

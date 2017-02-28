# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils
DESCRIPTION="Lumina desktop environment"
HOMEPAGE="http://lumina-desktop.org/"
I18N="161211"
SRC_URI="https://github.com/trueos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~grozin/${PN}-i18n-${I18N}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
LANGS="af ar az bg bn bs ca cs cy da de el en_GB en_ZA es et eu fa fi fr fr_CA fur gl he hi hr hu id is it ja ka ko lt lv mk mn ms mt nb ne nl pa pl pt pt_BR ro ru sa sk sl sr sv sw ta tg th tr uk ur uz vi zh_CN zh_HK zh_TW zu"
for lang in ${LANGS}; do
	IUSE="${IUSE} linguas_${lang}"
done

COMMON_DEPEND="dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtsvg:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	x11-libs/libxcb:0
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-wm"

DEPEND="$COMMON_DEPEND
	dev-qt/linguist-tools:5"

RDEPEND="$COMMON_DEPEND
	kde-frameworks/oxygen-icons
	x11-misc/numlockx
	x11-wm/fluxbox
	x11-apps/xbacklight
	media-sound/alsa-utils
	sys-power/acpi
	app-admin/sysstat"

src_configure(){
	eqmake5 PREFIX="${ROOT}usr" L_BINDIR="${ROOT}usr/bin" \
		L_ETCDIR="${ROOT}etc" L_LIBDIR="${ROOT}usr/$(get_libdir)" \
		LIBPREFIX="${ROOT}usr/$(get_libdir)" DESTDIR="${D}"
}

src_install(){
	default
	mv "${D}"/etc/luminaDesktop.conf.dist "${D}"/etc/luminaDesktop.conf || die
	rm "${D}"/${PN}-* "${D}"/start-${PN}-desktop || die
	mkdir "${D}"/usr/share/${PN}-desktop/i18n
	for lang in ${LANGS}; do
		if use linguas_${lang}; then
			cp ../${PN}-i18n/*_${lang}.qm "${D}"/usr/share/${PN}-desktop/i18n/ || die "Language ${lang} not found"
		fi
	done
}

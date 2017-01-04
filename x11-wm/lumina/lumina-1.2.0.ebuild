# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
LANGS="af ar az bg bn bs ca cs cy da de el en-GB en-ZA es et eu fa fi fr fr-CA gl he hi hr hu id is it ja ka ko lt lv mk mn ms nb ne nl pa pl pt pt-BR ro ru sa sk sl sr sv sw ta tg th tr uk uz vi zh-CN zh-HK zh-TW zu"
for lang in ${LANGS}; do
	IUSE="${IUSE} l10n_${lang}"
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
	|| ( virtual/freedesktop-icon-theme
	x11-themes/hicolor-icon-theme )
	sys-fs/inotify-tools
	x11-misc/numlockx
	x11-wm/fluxbox
	x11-apps/xbacklight
	media-sound/alsa-utils
	sys-power/acpi
	app-admin/sysstat"

src_prepare(){
	default

	rm -rf src-qt5/desktop-utils || die

	sed -e "/desktop-utils/d" -i src-qt5/src-qt5.pro || die
}

src_configure(){
	eqmake5 PREFIX="${EPREFIX}/usr" L_BINDIR="${EPREFIX}/usr/bin" \
		L_ETCDIR="${EPREFIX}/etc" L_LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		LIBPREFIX="${EPREFIX}/usr/$(get_libdir)" DESTDIR="${D}"
}

src_install(){
	default
	mv "${ED%/}"/etc/luminaDesktop.conf{.dist,} || die
	rm "${ED%/}"/${PN}-* "${ED%/}"/start-${PN}-desktop || die
	mkdir "${ED%/}"/usr/share/${PN}-desktop/i18n || die
	for lang in ${LANGS}; do
		make lang local
		if use l10n_${lang}; then
			cp ../${PN}-i18n/*_${lang}.qm "${ED%/}"/usr/share/${PN}-desktop/i18n/ || die "Language ${lang} not found"
		fi
	done
}

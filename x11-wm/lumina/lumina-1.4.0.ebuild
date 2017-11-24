# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils
DESCRIPTION="Lumina desktop environment"
HOMEPAGE="https://lumina-desktop.org/"
SRC_URI="https://github.com/trueos/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="desktop-utils"

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
	x11-libs/xcb-util-wm
	desktop-utils? ( app-text/poppler[qt5] )"

DEPEND="$COMMON_DEPEND
	dev-qt/linguist-tools:5"

RDEPEND="$COMMON_DEPEND
	sys-fs/inotify-tools
	x11-misc/numlockx
	x11-wm/fluxbox
	|| ( x11-apps/xbacklight
		sys-power/acpilight )
	media-sound/alsa-utils
	sys-power/acpi
	app-admin/sysstat"

S="${WORKDIR}/${P/_/-}"

PATCHES=(
	"${FILESDIR}/1.2.0-desktop-files.patch"
	"${FILESDIR}/1.3.0-OS-detect.patch"
)

src_prepare(){
	default

	if use !desktop-utils ; then
		rm -rf src-qt5/desktop-utils || die
		sed -e "/desktop-utils/d" -i src-qt5/src-qt5.pro || die
	fi
}

src_configure(){
	eqmake5 PREFIX="${EPREFIX}/usr" LIBPREFIX="${EPREFIX}/usr/$(get_libdir)" \
		DESTDIR="${D}" CONFIG+=WITH_I18N QMAKE_CFLAGS_ISYSTEM=
}

src_install(){
	# A hack to avoid sandbox violation and install liblthemeengine*.so to the correct places
	emake install INSTALL_ROOT="${D}"
	rm "${ED%/}"/${PN}-* "${ED%/}"/start-${PN}-desktop "${ED%/}"/liblthemeengine*.so "${ED%/}"/lthemeengine || die
	mv "${D}/${D}/etc" "${D}/etc" || die
	mv "${D}/${D}/usr/bin" "${D}/usr/bin" || die
	mv "${D}/${D}/usr/share" "${D}/usr/share" || die
	rm -rf "${D}/var" || die
	mv "${ED%/}"/etc/luminaDesktop.conf{.dist,} || die
}

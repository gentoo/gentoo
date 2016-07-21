# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="cs de es he ru"
inherit cmake-utils l10n

MY_P=${PN}_${PV}

DESCRIPTION="Qt4 GUI ALSA tools: mixer, configuration browser"
HOMEPAGE="http://xwmw.org/qastools/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	>=dev-qt/qtcore-4.6:4
	>=dev-qt/qtgui-4.6:4
	>=dev-qt/qtsvg-4.6:4
	virtual/libudev"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

S=${WORKDIR}/${MY_P}
DOCS=( CHANGELOG README TODO )

rm_loc() {
	rm i18n/ts/app_${1}.ts || die "removing ${1} locale failed"
}

src_prepare() {
	cmake-utils_src_prepare
	l10n_for_each_disabled_locale_do rm_loc
}

src_configure() {
	local mycmakeargs=( -DSKIP_LICENSE_INSTALL=TRUE )
	cmake-utils_src_configure
}

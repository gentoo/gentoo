# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qastools/qastools-0.17.2.ebuild,v 1.3 2013/07/02 13:45:22 kensington Exp $

EAPI=5

inherit cmake-utils

MY_P=${PN}_${PV}

DESCRIPTION="Qt4 GUI ALSA tools: mixer, configuration browser"
HOMEPAGE="http://xwmw.org/qastools/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

LANGS="cs de es ru"
for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

RDEPEND="media-libs/alsa-lib
	>=dev-qt/qtcore-4.6:4
	>=dev-qt/qtgui-4.6:4
	>=dev-qt/qtsvg-4.6:4"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

S=${WORKDIR}/${MY_P}

DOCS=( CHANGELOG README TODO )

src_prepare() {
	cmake-utils_src_prepare

	local lang
	for lang in ${LANGS} ; do
		if ! use linguas_${lang} ; then
			rm i18n/ts/app_${lang}.ts
		fi
	done
}

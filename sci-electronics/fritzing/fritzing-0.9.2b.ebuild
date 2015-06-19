# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/fritzing/fritzing-0.9.2b.ebuild,v 1.2 2015/04/22 17:37:39 kensington Exp $

EAPI=5

inherit qmake-utils

DESCRIPTION="Electronic Design Automation"
HOMEPAGE="http://fritzing.org/"
SRC_URI="https://github.com/fritzing/fritzing-app/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-3.0 GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtserialport:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-libs/quazip"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.40"

S="${WORKDIR}/${PN}-app-${PV}"

src_prepare() {
	local translations=

	# Get a rid of the bundled libs
	# Bug 412555 and
	# https://code.google.com/p/fritzing/issues/detail?id=1898
	rm -rf src/lib/quazip/ pri/quazip.pri src/lib/boost*

	# Fritzing doesn't need zlib
	sed -i -e 's:LIBS += -lz::' -e 's:-lminizip::' phoenix.pro || die

	edos2unix ${PN}.desktop

	# Somewhat evil but IMHO the best solution
	for lang in $LINGUAS; do
		lang=${lang/linguas_}
		[ -f "translations/${PN}_${lang}.qm" ] && translations+=" translations/${PN}_${lang}.qm"
	done
	if [ -n "${translations}" ]; then
		sed -i -e "s:\(translations.extra =\) .*:\1	cp -p ${translations} \$(INSTALL_ROOT)\$\$PKGDATADIR/translations\r:" phoenix.pro || die
	else
		sed -i -e "s:translations.extra = .*:\r:" phoenix.pro || die
	fi
}

src_configure() {
	eqmake5 DEFINES=QUAZIP_INSTALLED PREFIX="${D}"/usr phoenix.pro
}

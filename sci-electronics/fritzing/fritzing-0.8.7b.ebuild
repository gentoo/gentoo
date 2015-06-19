# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/fritzing/fritzing-0.8.7b.ebuild,v 1.1 2014/02/05 01:16:30 mrueg Exp $

EAPI=5

inherit eutils qt4-r2

DESCRIPTION="Electronic Design Automation"
HOMEPAGE="http://fritzing.org/"
SRC_URI="http://fritzing.org/download/${PV}/source-tarball/${P}.source.tar.bz2"

LICENSE="CC-BY-SA-3.0 GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	dev-qt/qtsql:4[sqlite]
	dev-libs/quazip"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.40"

S="${WORKDIR}/${P}.source"

src_prepare() {
	local translations=

	qt4-r2_src_prepare

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
	eqmake4 DEFINES=QUAZIP_INSTALLED phoenix.pro
}

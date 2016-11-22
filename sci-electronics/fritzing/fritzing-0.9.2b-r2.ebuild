# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PARTS_P="${PN}-parts-${PV}"

inherit qmake-utils

DESCRIPTION="Electronic Design Automation"
HOMEPAGE="http://fritzing.org/"
SRC_URI="https://github.com/fritzing/fritzing-app/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/fritzing/fritzing-parts/archive/${PV}.tar.gz -> ${PARTS_P}.tar.gz"

LICENSE="CC-BY-SA-3.0 GPL-3+"
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
	>=dev-libs/quazip-0.7.2[qt5]"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.40"

S="${WORKDIR}/${PN}-app-${PV}"

DOCS="readme.md"

src_prepare() {
	local lang translations=

	# fix build with newer quazip - bug #597988
	sed -i -e "s/#include <quazip/&5/" src/utils/folderutils.cpp || die
	sed -i -e "s|/usr/include/quazip|&5|" -e "s/-lquazip/&5/" phoenix.pro || die

	# Get a rid of the bundled libs
	# Bug 412555 and
	# https://code.google.com/p/fritzing/issues/detail?id=1898
	rm -rf src/lib/quazip/ pri/quazip.pri src/lib/boost* || die

	# Fritzing doesn't need zlib
	sed -i -e 's:LIBS += -lz::' -e 's:-lminizip::' phoenix.pro || die

	# Somewhat evil but IMHO the best solution
	for lang in $L10N; do
		lang=${lang/linguas_}
		[[ -f "translations/${PN}_${lang}.qm" ]] && translations+=" translations/${PN}_${lang}.qm"
	done
	if [[ -n "${translations}" ]]; then
		sed -i -e "s:\(translations.extra =\) .*:\1	cp -p ${translations} \$(INSTALL_ROOT)\$\$PKGDATADIR/translations\r:" phoenix.pro || die
	else
		sed -i -e "s:translations.extra = .*:\r:" phoenix.pro || die
	fi

	# Fix missing Intel bin icon
	# https://github.com/fritzing/fritzing-parts/commit/716560e9
	sed -i -e 's:Intel.png:intel.png:' bins/more/intel.fzb || die

	default
}

src_configure() {
	eqmake5 DEFINES=QUAZIP_INSTALLED phoenix.pro
}

src_install() {
	INSTALL_ROOT="${D}" default

	insinto /usr/share/fritzing/parts
	doins -r "${WORKDIR}/${PARTS_P}"/*
}

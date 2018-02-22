# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

MY_P=qt-solutions-${PV#*_p}

DESCRIPTION="Qt library to start applications only once per user"
HOMEPAGE="https://code.qt.io/cgit/qt-solutions/qt-solutions.git/"
SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="doc X"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtlockedfile[qt5(+)]
	dev-qt/qtnetwork:5
	X? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/${PN}"

PATCHES=(
	"${FILESDIR}/2.6.1_p20130904-unbundle-qtlockedfile.patch"
	"${FILESDIR}/2.6.1_p20130904-no-gui.patch"
)

src_prepare() {
	default

	echo 'SOLUTIONS_LIBRARY = yes' > config.pri
	use X || echo 'QTSA_NO_GUI = yes' >> config.pri

	sed -i -e "s/-head/-${PV%.*}/" common.pri || die
	sed -i -e '/SUBDIRS+=examples/d' ${PN}.pro || die

	# to ensure unbundling
	rm src/qtlockedfile* || die
}

src_configure() {
	eqmake5
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )

	# libraries
	dolib.so lib/*

	# headers
	insinto "$(qt5_get_headerdir)"/QtSolutions
	doins src/qtsinglecoreapplication.h
	use X && doins src/{QtSingleApplication,${PN}.h}

	# .prf files
	insinto "$(qt5_get_mkspecsdir)"/features
	doins "${FILESDIR}"/qtsinglecoreapplication.prf
	use X && doins "${FILESDIR}"/${PN}.prf

	default
}

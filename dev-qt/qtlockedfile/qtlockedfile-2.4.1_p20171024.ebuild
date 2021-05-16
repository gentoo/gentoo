# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=qt-solutions-${PV#*_p}
inherit qmake-utils

DESCRIPTION="QFile extension with advisory locking functions"
HOMEPAGE="https://code.qt.io/cgit/qt-solutions/qt-solutions.git/"
SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 x86"
IUSE="doc"

DEPEND="dev-qt/qtcore:5"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/${PN}"

src_prepare() {
	default

	echo 'SOLUTIONS_LIBRARY = yes' > config.pri
	echo 'QT -= gui' >> src/qtlockedfile.pri

	sed -i -e "s/-head/-${PV%.*}/" common.pri || die
	sed -i -e '/SUBDIRS+=example/d' ${PN}.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )
	einstalldocs

	# libraries
	dolib.so lib/*

	# headers
	insinto "$(qt5_get_headerdir)"/QtSolutions
	doins src/QtLockedFile src/${PN}.h

	# .prf files
	insinto "$(qt5_get_mkspecsdir)"/features
	doins "${FILESDIR}"/${PN}.prf
}

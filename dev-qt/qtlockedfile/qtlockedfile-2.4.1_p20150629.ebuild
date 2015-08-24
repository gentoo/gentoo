# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multibuild qmake-utils

MY_P=qt-solutions-${PV#*_p}

DESCRIPTION="QFile extension with advisory locking functions"
HOMEPAGE="https://code.qt.io/cgit/qt-solutions/qt-solutions.git/"
SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc +qt4 qt5"

REQUIRED_USE="|| ( qt4 qt5 )"

DEPEND="
	qt4? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtcore:5 )
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/${PN}

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_prepare() {
	echo 'SOLUTIONS_LIBRARY = yes' > config.pri
	echo 'QT -= gui' >> src/qtlockedfile.pri

	sed -i -e "s/-head/-${PV%.*}/" common.pri || die
	sed -i -e '/SUBDIRS+=example/d' ${PN}.pro || die

	multibuild_copy_sources
}

src_configure() {
	myconfigure() {
		if [[ ${MULTIBUILD_VARIANT} == qt4 ]]; then
			eqmake4
		fi
		if [[ ${MULTIBUILD_VARIANT} == qt5 ]]; then
			eqmake5
		fi
	}
	multibuild_foreach_variant run_in_build_dir myconfigure
}

src_compile() {
	multibuild_foreach_variant run_in_build_dir default
}

src_install() {
	dodoc README.TXT
	use doc && dodoc -r doc/html

	myinstall() {
		# libraries
		dolib.so lib/*

		# headers
		insinto "$(${MULTIBUILD_VARIANT}_get_headerdir)"/QtSolutions
		doins src/QtLockedFile src/${PN}.h

		# .prf files
		insinto "$(${MULTIBUILD_VARIANT}_get_mkspecsdir)"/features
		doins "${FILESDIR}"/${PN}.prf
	}
	multibuild_foreach_variant run_in_build_dir myinstall
}

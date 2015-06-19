# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtsingleapplication/qtsingleapplication-2.6.1_p20130904-r4.ebuild,v 1.1 2015/05/11 15:44:05 pesa Exp $

EAPI=5

inherit multibuild qmake-utils

MY_P=qt-solutions-${PV#*_p}

DESCRIPTION="Qt library to start applications only once per user"
HOMEPAGE="http://doc.qt.digia.com/solutions/4/qtsingleapplication/index.html"
SRC_URI="http://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc +qt4 qt5 X"

REQUIRED_USE="|| ( qt4 qt5 )"

DEPEND="
	dev-qt/qtlockedfile[qt4?,qt5?]
	qt4? (
		dev-qt/qtcore:4
		X? ( dev-qt/qtgui:4 )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		X? (
			dev-qt/qtgui:5
			dev-qt/qtwidgets:5
		)
	)
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/${PN}

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_prepare() {
	epatch "${FILESDIR}/${PV}-unbundle-qtlockedfile.patch"
	epatch "${FILESDIR}/${PV}-no-gui.patch"

	echo 'SOLUTIONS_LIBRARY = yes' > config.pri
	use X || echo 'QTSA_NO_GUI = yes' >> config.pri

	sed -i -e "s/-head/-${PV%.*}/" common.pri || die
	sed -i -e '/SUBDIRS+=examples/d' ${PN}.pro || die

	# to ensure unbundling
	rm -f src/qtlockedfile*

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
		doins src/qtsinglecoreapplication.h
		use X && doins src/{QtSingleApplication,${PN}.h}

		# .prf files
		insinto "$(${MULTIBUILD_VARIANT}_get_mkspecsdir)"/features
		doins "${FILESDIR}"/qtsinglecoreapplication.prf
		use X && doins "${FILESDIR}"/${PN}.prf
	}

	multibuild_foreach_variant run_in_build_dir myinstall
}

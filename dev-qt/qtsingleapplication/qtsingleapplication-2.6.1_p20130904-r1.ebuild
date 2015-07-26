# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtsingleapplication/qtsingleapplication-2.6.1_p20130904-r1.ebuild,v 1.9 2015/07/25 15:54:49 maekke Exp $

EAPI=5

inherit qt4-r2

MY_P=qt-solutions-${PV#*_p}

DESCRIPTION="Qt library to start applications only once per user"
HOMEPAGE="https://code.qt.io/cgit/qt-solutions/qt-solutions.git/"
SRC_URI="http://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="X doc"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtlockedfile
	X? ( dev-qt/qtgui:4 )
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/${PN}

PATCHES=(
	"${FILESDIR}/${PV}-unbundle-qtlockedfile.patch"
	"${FILESDIR}/${PV}-no-gui.patch"
)

src_prepare() {
	qt4-r2_src_prepare

	echo 'SOLUTIONS_LIBRARY = yes' > config.pri
	use X || echo 'QTSA_NO_GUI = yes' >> config.pri

	sed -i -e "s/-head/-${PV%.*}/" common.pri || die
	sed -i -e '/SUBDIRS+=examples/d' ${PN}.pro || die

	# to ensure unbundling
	rm -f src/qtlockedfile*
}

src_install() {
	dodoc README.TXT

	dolib.so lib/*
	insinto /usr/include/qt4/QtSolutions
	doins src/qtsinglecoreapplication.h
	use X && doins src/{QtSingleApplication,${PN}.h}

	insinto /usr/share/qt4/mkspecs/features
	doins "${FILESDIR}"/qtsinglecoreapplication.prf
	use X && doins "${FILESDIR}"/${PN}.prf

	use doc && dohtml -r doc/html
}

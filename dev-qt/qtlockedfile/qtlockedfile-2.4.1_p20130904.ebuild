# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtlockedfile/qtlockedfile-2.4.1_p20130904.ebuild,v 1.7 2015/05/16 11:20:06 pacho Exp $

EAPI=5

inherit qt4-r2

MY_P=qt-solutions-${PV#*_p}

DESCRIPTION="QFile extension with advisory locking functions"
HOMEPAGE="http://doc.qt.digia.com/solutions/4/qtlockedfile/index.html"
SRC_URI="http://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="dev-qt/qtcore:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/${PN}

src_prepare() {
	qt4-r2_src_prepare

	echo 'SOLUTIONS_LIBRARY = yes' > config.pri
	echo 'QT -= gui' >> src/qtlockedfile.pri

	sed -i -e "s/-head/-${PV%.*}/" common.pri || die
	sed -i -e '/SUBDIRS+=example/d' ${PN}.pro || die
}

src_install() {
	dodoc README.TXT

	dolib.so lib/*
	insinto /usr/include/qt4/QtSolutions/
	doins src/QtLockedFile src/${PN}.h

	insinto /usr/share/qt4/mkspecs/features/
	doins "${FILESDIR}"/${PN}.prf

	use doc && dohtml -r doc/html
}

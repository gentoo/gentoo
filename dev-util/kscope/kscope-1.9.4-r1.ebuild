# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kscope/kscope-1.9.4-r1.ebuild,v 1.5 2013/04/17 09:03:44 ssuominen Exp $

EAPI=5

inherit eutils multilib qt4-r2

DESCRIPTION="Source Editing Environment based on Qt"
HOMEPAGE="http://kscope.sourceforge.net/"
SRC_URI="mirror://sourceforge/kscope/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	x11-libs/qscintilla"
DEPEND="${RDEPEND}"

DOCS="ChangeLog"

src_prepare() {
	sed -i -e "s:/usr/local:/usr:" config || die
	sed -i \
		-e "s:\$\${QSCI_ROOT_PATH}/include/Qsci:& /usr/include/qt4/Qsci:g" \
		-e "s:\$\${QSCI_ROOT_PATH}/lib:& -L/usr/lib/qt4:g" \
		-e "s:/lib:/$(get_libdir):g" \
		app/app.pro core/core.pro cscope/cscope.pro editor/editor.pro \
		|| die

	# fix build failure with parallel make
	echo "CONFIG += ordered" >> kscope.pro

	epatch "${FILESDIR}/${P}"-{actions,underlinking}.patch
}

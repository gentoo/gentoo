# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} != *9999* ]]; then
	KDE_LINGUAS="ar bg br bs ca ca@valencia cs cy da de el en_GB eo es et fr ga
	gl hi hne hr hu is it ja ka lt mai ml nb nds nl nn pl pt pt_BR ro ru rw sk
	sv ta tg tr ug uk zh_CN zh_TW"
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux"
	KDE_HANDBOOK="optional"
else
	KEYWORDS=""
fi

KDE_REQUIRED="optional"
inherit kde4-base qmake-utils

DESCRIPTION="Qt/KDE based frontend to diff3"
HOMEPAGE="http://kdiff3.sourceforge.net/"
EGIT_REPO_URI=( "git://git.code.sf.net/p/kdiff3/code" )

LICENSE="GPL-2"
SLOT="4"
IUSE="debug kde +qt4 qt5"

REQUIRED_USE="kde? ( qt4 )
	^^ ( qt4 qt5 )"

CDEPEND="
	qt4? ( dev-qt/qtcore:4
		dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5 )
	kde? ( $(add_kdebase_dep kdelibs) )
"
DEPEND="${CDEPEND}
	sys-devel/gettext
"
RDEPEND="${CDEPEND}
	sys-apps/diffutils
"

RESTRICT="!kde? ( test )"

src_unpack(){
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		mv "${S}"/${PN}/* "${S}" || die
	else
		default
	fi
}

src_prepare() {
	if ! use kde; then
		# adapt to Gentoo paths
		sed -e s,documentation.path.*$,documentation.path\ =\ "${EPREFIX}"/usr/share/doc/"${PF}", \
		-e s,target.path.*$,target.path\ =\ "${EPREFIX}"/usr/bin, \
		"${S}"/src-QT4/kdiff3.pro > "${S}"/src-QT4/kdiff3_fixed.pro
	else
		kde4-base_src_prepare
	fi
}

src_configure() {
	if use kde; then
		kde4-base_src_configure
	elif use qt4; then
		eqmake4 "${S}"/src-QT4/kdiff3_fixed.pro
	else
		eqmake5 "${S}"/src-QT4/kdiff3_fixed.pro
	fi
}

src_compile() {
	if use kde; then
		kde4-base_src_compile
	else
		default
	fi
}

src_install() {
	if use kde; then
		kde4-base_src_install
	else
		emake INSTALL_ROOT="${D}" install
	fi
}

src_test() {
	if use kde; then
		kde4-base_src_test
	fi
}

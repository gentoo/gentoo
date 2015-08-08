# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} != *9999* ]]; then
	KDE_LINGUAS="ar bg br bs ca ca@valencia cs cy da de el en_GB eo es et fr ga
	gl hi hne hr hu is it ja ka lt mai ml nb nds nl nn pl pt pt_BR ro ru rw sk
	sv ta tg tr ug uk zh_CN zh_TW"
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 ~ppc x86 ~amd64-linux"
	KDE_HANDBOOK="optional"
else
	ESVN_REPO_URI="https://kdiff3.svn.sourceforge.net/svnroot/kdiff3/trunk/kdiff3"
	KEYWORDS=""
fi

KDE_REQUIRED="optional"
inherit kde4-base qt4-r2

DESCRIPTION="Qt/KDE based frontend to diff3"
HOMEPAGE="http://kdiff3.sourceforge.net/"

LICENSE="GPL-2"
SLOT="4"
IUSE="debug kde"

CDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	kde? ( $(add_kdebase_dep kdelibs) )
"
DEPEND="${CDEPEND}
	sys-devel/gettext
"
RDEPEND="${CDEPEND}
	sys-apps/diffutils
"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.97-relativepath.patch"
)

RESTRICT="!kde? ( test )"

src_unpack(){
	if [[ ${PV} == *9999* ]]; then
		subversion_src_unpack
	elif use kde; then
		kde4-base_src_unpack
	else
		qt4-r2_src_unpack
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
	else
		eqmake4 "${S}"/src-QT4/kdiff3_fixed.pro
	fi
}

src_compile() {
	if use kde; then
		kde4-base_src_compile
	else
		qt4-r2_src_compile
	fi
}

src_install() {
	if use kde; then
		kde4-base_src_install
	else
		qt4-r2_src_install
	fi
}

src_test() {
	if use kde; then
		kde4-base_src_test
	fi
}

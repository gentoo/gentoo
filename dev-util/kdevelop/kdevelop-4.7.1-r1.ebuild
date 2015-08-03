# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdevelop/kdevelop-4.7.1-r1.ebuild,v 1.1 2015/08/03 13:09:33 kensington Exp $

EAPI=5

KDE_LINGUAS="bs ca ca@valencia da de el en_GB es et fi fr gl hu it kk nb nds nl
pl pt pt_BR ru sk sl sv th tr uk zh_CN zh_TW"
VIRTUALX_REQUIRED="test"
EGIT_BRANCH="4.7"
inherit kde4-base

DESCRIPTION="Integrated Development Environment for Unix, supporting KDE/Qt, C/C++ and many other languages"
LICENSE="GPL-2 LGPL-2"
IUSE="+cmake +cxx debug +gdbui okteta qthelp"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="~amd64 ~ppc ~x86"
fi

DEPEND="
	dev-libs/qjson
	dev-qt/qtdeclarative:4[webkit]
	gdbui? (
		$(add_kdebase_dep ksysguard)
		$(add_kdebase_dep libkworkspace)
	)
	okteta? ( $(add_kdeapps_dep okteta) )
	qthelp? ( dev-qt/qthelp:4 )
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kapptemplate)
	$(add_kdeapps_dep kdebase-kioslaves)
	cxx? ( >=sys-devel/gdb-7.0[python] )
"
RESTRICT="test"
# see bug 366471

PATCHES=( "${FILESDIR}/${P}-gdb.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build cmake)
		$(cmake-utils_use_build cmake cmakebuilder)
		$(cmake-utils_use_build cxx cpp)
		$(cmake-utils_use_with gdbui KDE4Workspace)
		$(cmake-utils_use_with okteta LibKasten)
		$(cmake-utils_use_with okteta LibOkteta)
		$(cmake-utils_use_with okteta LibOktetaKasten)
		$(cmake-utils_use_build qthelp)
	)

	kde4-base_src_configure
}

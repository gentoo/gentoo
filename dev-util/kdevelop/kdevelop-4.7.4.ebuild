# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_LINGUAS="bs ca ca@valencia da de el en_GB es et fi fr gl hu it kk nb nds nl
pl pt pt_BR ru sk sl sv th tr uk zh_CN zh_TW"
VIRTUALX_REQUIRED="test"
WEBKIT_REQUIRED="always"
inherit kde4-base

DESCRIPTION="Integrated Development Environment, supporting KDE/Qt, C/C++ and much more"
LICENSE="GPL-2 LGPL-2"
IUSE="+cmake +cxx debug okteta qthelp"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="
	dev-libs/qjson[qt4(+)]
	dev-qt/qtdeclarative:4[webkit]
	okteta? ( $(add_kdeapps_dep okteta) )
	qthelp? ( dev-qt/qthelp:4 )
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kapptemplate)
	$(add_kdeapps_dep kdebase-kioslaves)
	cxx? ( >=sys-devel/gdb-7.0[python] )
"
# bug 366471
RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		-DWITH_KDE4Workspace=OFF
		-DBUILD_cmake=$(usex cmake)
		-DBUILD_cmakebuilder=$(usex cmake)
		-DBUILD_cpp=$(usex cxx)
		-DWITH_LibKasten=$(usex okteta)
		-DWITH_LibOkteta=$(usex okteta)
		-DWITH_LibOktetaKasten=$(usex okteta)
		-DBUILD_qthelp=$(usex qthelp)
	)

	kde4-base_src_configure
}

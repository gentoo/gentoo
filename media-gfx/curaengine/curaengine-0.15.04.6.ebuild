# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

MY_PV=${PV#0.}
MY_PN=CuraEngine

SRC_URI="https://github.com/Ultimaker/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="A 3D model slicing engine for 3D printing"
HOMEPAGE="https://github.com/Ultimaker/CuraEngine"

LICENSE="AGPL-3"
SLOT="0"
IUSE="test"

RDEPEND=""
DEPEND=""

S="${WORKDIR}/${MY_PN}-${MY_PV}"
PATCHES=( "${FILESDIR}"/${P}-cflags.patch )

src_prepare() {
	tc-export CXX
	default
}

src_test() {
	pushd tests 2>&- || die
	einfo "Commencing test ..."
	local testbin=( "${S}/build/CuraEngine" "-c" "supportAngle=60" "-c" "supportEverywhere=1" )
	local testmdl="${S}/tests/testModel.stl"
	${testbin[*]} "${testmdl}"
	if [[ $? -eq 0 && -f "${testbin[0]}" && -f "${testmdl}" ]]; then
		einfo "Test completed successfully."
	else
		ewarn "Test failed."
	fi
	popd 2>&- || die
}

src_install() {
	dobin build/CuraEngine
	dodoc README.md
}

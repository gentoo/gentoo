# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A cross-platform userland SCTP stack"
HOMEPAGE="https://github.com/sctplab/usrsctp"
SRC_URI="https://github.com/sctplab/usrsctp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( LICENSE.md Manual.md README.md )
PATCHES=( "${FILESDIR}/${P}-pc-inc-path.patch" )

src_configure() {
	local mycmakeargs=(
		-Dsctp_werror=0
		-Dsctp_build_programs=0
		-Dsctp_build_shared_lib=1
	)
	cmake_src_configure
}

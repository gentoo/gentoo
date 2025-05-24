# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A cross-platform userland SCTP stack"
HOMEPAGE="https://github.com/sctplab/usrsctp"
GIT_REV=881513ab3fc75b4c53ffce7b22b08e7b07fcc67a
SRC_URI="https://github.com/sctplab/usrsctp/archive/${GIT_REV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GIT_REV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

DOCS=( LICENSE.md Manual.md README.md )
PATCHES=( "${FILESDIR}/${PN}-0.9.5.0-cmake-4.patch" )

src_configure() {
	local mycmakeargs=(
		-Dsctp_werror=0
		-Dsctp_build_programs=0
		-Dsctp_build_shared_lib=1
	)
	cmake_src_configure
}

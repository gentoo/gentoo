# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Header-only library for creating parsers according to Parsing Expression Grammar"
HOMEPAGE="https://github.com/taocpp/PEGTL"
SRC_URI="https://github.com/taocpp/PEGTL/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P^^}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.1-werror.patch
)

src_configure() {
	local mycmakeargs=(
		-DPEGTL_INSTALL_CMAKE_DIR="$(get_libdir)/cmake/${PN}"
		-DPEGTL_INSTALL_DOC_DIR="share/doc/${PF}"
	)
	cmake_src_configure
}

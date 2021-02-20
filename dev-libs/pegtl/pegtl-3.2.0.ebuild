# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Header-only library for creating parsers according to Parsing Expression Grammar"
HOMEPAGE="https://github.com/taocpp/PEGTL"
SRC_URI="https://github.com/taocpp/PEGTL/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${P^^}"

src_configure() {
	local mycmakeargs=(
		-DPEGTL_INSTALL_CMAKE_DIR="$(get_libdir)/cmake/${PN}"
		-DPEGTL_INSTALL_DOC_DIR="share/doc/${PF}"
	)
	cmake_src_configure
}

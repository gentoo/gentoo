# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Wayland C++ bindings"
HOMEPAGE="https://github.com/NilsBrause/waylandpp"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="doc"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/NilsBrause/waylandpp.git"
	inherit git-r3
else
	SRC_URI="https://github.com/NilsBrause/waylandpp/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

RDEPEND="
	>=dev-libs/pugixml-1.9-r1
	>=dev-libs/wayland-1.11.0
"
DEPEND="${RDEPEND}
	media-libs/libglvnd
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
	"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
	)

	cmake_src_configure
}

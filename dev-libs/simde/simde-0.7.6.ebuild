# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Header-only library providing implementations of SIMD instruction sets"
HOMEPAGE="https://simd-everywhere.github.io/blog/"
SRC_URI="
	https://github.com/simd-everywhere/simde/archive/refs/tags/v${PV/_/-}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	# *FLAGS are only used for tests (nothing that is installed), and
	# upstream tests with specific *FLAGS and is otherwise flaky with
	# -march=native, -mno-*, and such -- unset to be spared headaches.
	unset {C,CPP,CXX,LD}FLAGS

	local emesonargs=(
		$(meson_use test tests)
	)

	meson_src_configure
}

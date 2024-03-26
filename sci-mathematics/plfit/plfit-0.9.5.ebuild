# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fit power-law distributions to empirical data"
HOMEPAGE="https://github.com/ntamas/plfit"
SRC_URI="https://github.com/ntamas/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"
# plfit is gpl-2 and its source headers say "or later." The upstream
# doc/ directory contains MIT and BSD licenses for two components.
LICENSE="BSD GPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse cpu_flags_x86_sse2"

DOCS=( CHANGELOG.md README.rst doc/THANKS )

src_configure() {
	local mycmakeargs=(
		-DPLFIT_COMPILE_PYTHON_MODULE=OFF
		-DPLFIT_USE_SSE=OFF
		-DPLFIT_USE_OPENMP=OFF
	)
	if use cpu_flags_x86_sse || use cpu_flags_x86_sse2; then
		# plfit chooses which to use at compile time based on the
		# constants __SSE__ and __SSE2__.
		mycmakeargs+=( -DPLFIT_USE_SSE=ON )
	fi
	cmake_src_configure
}

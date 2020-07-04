# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake python-any-r1

DESCRIPTION="Cross platform unit testing framework for C and C++"
HOMEPAGE="https://github.com/Snaipe/Criterion"
SRC_URI="https://github.com/Snaipe/Criterion/releases/download/v${PV}/${PN}-v${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/nanomsg:="
DEPEND="${RDEPEND}
	test? (
		$(python_gen_any_dep 'dev-util/cram[${PYTHON_USEDEP}]')
	)"
BDEPEND="virtual/pkgconfig"

PATCHES="${FILESDIR}/${PN}-libdir.patch"
S="${WORKDIR}/${PN}-v${PV}"

QA_EXECSTACK="usr/lib*/libcriterion.so*"

python_check_deps() {
	has_version "dev-util/cram[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCTESTS="$(usex test ON OFF)"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use test; then
		cmake_build criterion_tests
	fi
}

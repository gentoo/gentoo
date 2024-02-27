# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )
inherit meson python-any-r1

DESCRIPTION="LC3 is an efficient low latency audio codec"
HOMEPAGE="https://github.com/google/liblc3"
SRC_URI="https://github.com/google/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test tools"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		$(python_gen_any_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	python_has_version "dev-python/numpy[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/scipy[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	use arm || rm -rf "test/arm" || die
	use arm64 || rm -rf "test/neon" || die
	default
}

src_configure() {
	local emesonargs=(
		# We let users choose to enable LTO
		-Db_lto=false
		$(meson_use tools)
	)
	meson_src_configure
}

src_test() {
	V= emake test CFLAGS:="${CPPFLAGS} ${CFLAGS} -I"$("${EPYTHON}" -c "import numpy;print(numpy.get_include())")""
}

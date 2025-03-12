# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} pypy3 )
inherit python-any-r1 toolchain-funcs meson-multilib

DESCRIPTION="LC3 is an efficient low latency audio codec"
HOMEPAGE="https://github.com/google/liblc3"
SRC_URI="https://github.com/google/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test tools"
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

multilib_src_prepare() {
	if ! use arm ; then
		rm -r "test/arm" || die
	fi

	if ! use arm64 ; then
		rm -r "test/neon" || die
	fi

	default
}

multilib_src_configure() {
	local emesonargs=(
		-Dpython=false
		$(meson_native_use_bool tools)
	)
	meson_src_configure
}

multilib_src_test() {
	if multilib_is_native_abi; then
		# Makefile misuses V=, so V=1 fails (e.g. "1cd ...")
		emake V= -C "${S}" test CC="$(tc-getCC)" \
			CFLAGS:="${CPPFLAGS} ${CFLAGS} -I"$("${EPYTHON}" -c "import numpy;print(numpy.get_include())")""
	else
		ewarn "Skipping test for non-native ABI: ${ABI}"
	fi
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python binding to the wlroots library using cffi"
HOMEPAGE="
	https://github.com/flacjacket/pywlroots/
	https://pypi.org/project/pywlroots/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="X"

# See README for wlroots dep
DEPEND="
	dev-python/cffi:=[${PYTHON_USEDEP}]
	>=dev-python/pywayland-0.4.14[${PYTHON_USEDEP}]
	>=dev-python/xkbcommon-0.2[${PYTHON_USEDEP}]
	=gui-libs/wlroots-$(ver_cut 1-2)*:=[X?]
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-0.15.24-no-import-version-check.patch
	)

	# override automagic detection and caching that's completely broken
	# by design; https://github.com/flacjacket/pywlroots/issues/132
	cat > wlroots/_build.py <<-EOF || die
		has_xwayland = $(usex X True False)
	EOF
	sed -e "s:return.*has_xwayland$:return $(usex X True False):" \
		-i wlroots/ffi_build.py || die

	distutils-r1_src_prepare
}

python_test() {
	rm -rf wlroots || die
	epytest
}

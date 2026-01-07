# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="sqlite,threads(+)"
DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 shell-completion edo

DESCRIPTION="C++ man pages for Linux, with source from cplusplus.com and cppreference.com"
HOMEPAGE="https://github.com/aitjcize/cppman"

SRC_URI="https://github.com/aitjcize/cppman/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~x64-macos"
IUSE="test"
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	sys-apps/groff
	$(python_gen_cond_dep '
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]')
"
BDEPEND="
	test? ( $(python_gen_cond_dep '
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]') )
"

src_prepare() {
	# Install data manually, nearly all of it is misplaced
	sed -i '/data_files = _data_files,/d' setup.py || die

	distutils-r1_src_prepare
}

python_test() {
	edo ${EPYTHON} test/test.py
}

src_install() {
	distutils-r1_src_install
	doman misc/cppman.1

	newbashcomp misc/completions/cppman.bash cppman
	dozshcomp misc/completions/zsh/_cppman
	dofishcomp misc/completions/fish/cppman.fish
}

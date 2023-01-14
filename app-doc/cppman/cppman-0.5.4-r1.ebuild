# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="sqlite,threads(+)"
DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 bash-completion-r1

DESCRIPTION="C++ man pages for Linux, with source from cplusplus.com and cppreference.com"
HOMEPAGE="https://github.com/aitjcize/cppman"
SRC_URI="https://github.com/aitjcize/cppman/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86 ~x64-macos"

RDEPEND="
	sys-apps/groff
	$(python_gen_cond_dep '
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
	')
"

src_prepare() {
	# Install data manually, nearly all of it is misplaced
	sed -i '/data_files = _data_files,/d' setup.py || die

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	doman misc/cppman.1

	newbashcomp misc/completions/cppman.bash cppman

	insinto /usr/share/zsh/site-functions
	doins misc/completions/zsh/_cppman

	insinto /usr/share/fish/vendor_completions.d
	doins misc/completions/fish/cppman.fish
}

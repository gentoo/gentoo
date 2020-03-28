# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="sqlite,threads(+)"

DISTUTILS_SINGLE_IMPL=true
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="C++ man pages for Linux, with source from cplusplus.com and cppreference.com"
HOMEPAGE="https://github.com/aitjcize/cppman"
SRC_URI="https://github.com/aitjcize/cppman/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"
IUSE="bash-completion zsh-completion"

RDEPEND="
	sys-apps/groff
	$(python_gen_cond_dep '
		dev-python/beautifulsoup:4[${PYTHON_MULTI_USEDEP}]
		dev-python/html5lib[${PYTHON_MULTI_USEDEP}]
	')
"

DOCS=( README.rst AUTHORS COPYING ChangeLog )

src_prepare() {
	sed -i '\:share/doc/cppman:d' setup.py
	use bash-completion || sed -i '\:share/bash-completion/completions:d' setup.py
	use zsh-completion || sed -i '\:share/zsh-completion/completions:d' setup.py

	default
}

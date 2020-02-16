# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite,threads"

DISTUTILS_SINGLE_IMPL=true

inherit distutils-r1

DESCRIPTION="C++ man pages for Linux, with source from cplusplus.com and cppreference.com"
HOMEPAGE="https://github.com/aitjcize/cppman"
LICENSE="GPL-3"

SLOT="0"
SRC_URI="https://github.com/aitjcize/cppman/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"

RDEPEND="
	sys-apps/groff
	$(python_gen_cond_dep '
		dev-python/beautifulsoup:4[${PYTHON_MULTI_USEDEP}]
		dev-python/html5lib[${PYTHON_MULTI_USEDEP}]
	')
"

# `./setup install` already installs docs
DOCS=()

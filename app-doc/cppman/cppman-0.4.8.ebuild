# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )
PYTHON_REQ_USE="sqlite,threads"

DISTUTILS_SINGLE_IMPL=true

inherit distutils-r1

DESCRIPTION="C++ man pages for Linux, with source from cplusplus.com and cppreference.com"
HOMEPAGE="https://github.com/aitjcize/cppman"
LICENSE="GPL-3"

SLOT="0"
SRC_URI="https://github.com/aitjcize/cppman/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	sys-apps/groff
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
"

# `./setup install` already installs docs
DOCS=()

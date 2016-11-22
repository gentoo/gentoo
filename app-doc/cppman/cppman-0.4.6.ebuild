# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_4)
PYTHON_REQ_USE='sqlite,threads'

inherit distutils-r1

DESCRIPTION="C++ man pages for Linux, with source from cplusplus.com and cppreference.com"
HOMEPAGE="https://github.com/aitjcize/cppman"
LICENSE="GPL-3"

SLOT="0"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	sys-apps/groff
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
"

# `./setup install` already installs docs
DOCS=()

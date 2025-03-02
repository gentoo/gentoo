# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1

DESCRIPTION="Remote control for Greenbone Vulnerability Manager, previously named openvas-cli"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/gvm-tools/"
SRC_URI="https://github.com/greenbone/gvm-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=net-analyzer/python-gvm-23.4.2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests unittest

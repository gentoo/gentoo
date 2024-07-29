# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1

DESCRIPTION="Remote control for Greenbone Vulnerability Manager, previously named openvas-cli"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/gvm-tools/"
SRC_URI="https://github.com/greenbone/gvm-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=net-analyzer/python-gvm-23.4.2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests unittest

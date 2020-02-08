# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="A library for shell script-like programs in python"
HOMEPAGE="https://plumbum.readthedocs.io/en/latest/ https://github.com/tomerfiliba/plumbum"
SRC_URI="https://github.com/tomerfiliba/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )
inherit distutils-r1

DESCRIPTION="Yet Another XML Differ"
HOMEPAGE="
	https://pypi.org/project/yaxmldiff/
	https://github.com/latk/yaxmldiff.py
"
SRC_URI="https://github.com/latk/${PN}.py/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}.py-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~loong ~x86"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
"

# no tests currently
RESTRICT="test"

python_prepare_all() {
	sed -i '/license_file/ d' setup.cfg || die
	distutils-r1_python_prepare_all
}

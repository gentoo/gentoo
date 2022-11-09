# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A custom YAML tag for referencing environment variables in YAML files"
HOMEPAGE="https://github.com/waylan/pyyaml-env-tag"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Python library for handling TOML files"
HOMEPAGE="https://github.com/uiri/toml"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# peculiar testing depending on https://github.com/BurntSushi/toml-test. Not
# particularly worth the trouble.
RESTRICT="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

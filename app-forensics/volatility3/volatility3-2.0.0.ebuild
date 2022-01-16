# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PV=${PV//_beta/-beta.}

DESCRIPTION="Framework for analyzing volatile memory"
HOMEPAGE="https://github.com/volatilityfoundation/volatility3/ https://www.volatilityfoundation.org/"
SRC_URI="https://github.com/volatilityfoundation/volatility3/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt disasm jsonschema leechcore snappy yara"

RDEPEND="
	>=dev-python/pefile-2017.8.1[${PYTHON_USEDEP}]
	crypt? ( >=dev-python/pycryptodome-3[${PYTHON_USEDEP}] )
	disasm? ( >=dev-libs/capstone-3.0.5[python,${PYTHON_USEDEP}] )
	jsonschema? ( >=dev-python/jsonschema-2.3.0[${PYTHON_USEDEP}] )
	leechcore? ( >=dev-python/leechcorepyc-2.4.0[${PYTHON_USEDEP}] )
	snappy? ( >=dev-python/snappy-0.6.0[${PYTHON_USEDEP}] )
	yara? ( >=dev-python/yara-python-3.8.0[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}"

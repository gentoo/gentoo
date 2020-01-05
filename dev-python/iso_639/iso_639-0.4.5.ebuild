# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )

MY_PN="iso-639"
MY_P="${MY_PN}-${PV}"

inherit distutils-r1

DESCRIPTION="Python library for ISO 639 standard"
HOMEPAGE="https://pypi.org/project/iso-639/ https://github.com/noumar/iso639"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

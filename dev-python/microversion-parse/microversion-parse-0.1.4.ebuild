# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A simple parser for OpenStack microversion headers"
HOMEPAGE="https://github.com/openstack/microversion-parse"
SRC_URI="mirror://pypi/${PN:0:1}/microversion_parse/microversion_parse-${PV}.tar.gz"
S="${WORKDIR}/microversion_parse-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
"

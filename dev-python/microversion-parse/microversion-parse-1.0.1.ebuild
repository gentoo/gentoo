# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="A simple parser for OpenStack microversion headers"
HOMEPAGE="https://github.com/openstack/microversion-parse"
SRC_URI="mirror://pypi/${PN:0:1}/microversion_parse/microversion_parse-${PV}.tar.gz"
S="${WORKDIR}/microversion_parse-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-python/pbr-5.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

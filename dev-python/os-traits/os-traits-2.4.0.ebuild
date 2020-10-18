# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_7 python3_8 )

inherit distutils-r1

DESCRIPTION="os-traits is a library containing standardized trait strings."
HOMEPAGE="https://github.com/openstack/os-traits"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND=">=dev-python/pbr-5.4.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

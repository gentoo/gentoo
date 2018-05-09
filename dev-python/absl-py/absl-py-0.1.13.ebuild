# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="Abseil Python Common Libraries"
HOMEPAGE="https://github.com/abseil/abseil-py"
SRC_URI="https://github.com/abseil/abseil-py/archive/pypi-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/six"
RDEPEND="${DEPEND}"

S="${WORKDIR}/abseil-py-pypi-v${PV}"

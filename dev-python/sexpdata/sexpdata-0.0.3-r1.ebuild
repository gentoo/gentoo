# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_7,3_8} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="a simple S-expression parser/serializer"
HOMEPAGE="https://github.com/jd-boyd/sexpdata"
SRC_URI="https://github.com/jd-boyd/sexpdata/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests || die
}

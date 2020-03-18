# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

MY_PN=Unidecode
MY_P=${MY_PN}-${PV}

inherit distutils-r1

DESCRIPTION="Module providing ASCII transliterations of Unicode text"
HOMEPAGE="https://pypi.org/project/Unidecode/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

S=${WORKDIR}/${MY_P}

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}

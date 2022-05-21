# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

MY_P=speaklater3-${PV}
DESCRIPTION="Lazy strings for Python"
HOMEPAGE="https://pypi.org/project/speaklater3/"
SRC_URI="mirror://pypi/s/speaklater3/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

python_test() {
	"${EPYTHON}" -m doctest -v speaklater.py ||
		die "tests failed with ${EPYTHON}"
}

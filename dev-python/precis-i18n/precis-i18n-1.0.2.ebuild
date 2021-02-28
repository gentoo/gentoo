# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Internationalized Usernames and Passwords"
HOMEPAGE="https://pypi.python.org/pypi/precis-i18n"
SRC_URI="mirror://pypi/${PN:0:1}/${PN/-/_}/${P/-/_}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_test() {
	# requires additional files not in tarball
	rm test/test_derived_props_files.py
	esetup.py test
}

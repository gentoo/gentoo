# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A Python module for semantic versioning"
HOMEPAGE="https://github.com/python-semver/python-semver"
SRC_URI="https://github.com/python-${PN}/python-${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/python-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

distutils_enable_tests pytest

python_prepare_all() {
	# contains pytest/cov args we don't want
	rm setup.cfg || die
	distutils-r1_python_prepare_all
}

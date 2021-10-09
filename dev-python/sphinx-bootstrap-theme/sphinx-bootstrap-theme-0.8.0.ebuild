# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1

# Upstream decided to move the v0.8.0 tag to another commit
# Restore the same git commit for old v0.8.0
MY_COMMIT="a6dfc6f9054f6b4cf3eb1acadf715a679ed53a7b"

DESCRIPTION="Sphinx theme integrates the Bootstrap CSS / JavaScript framework"
HOMEPAGE="https://ryan-roemer.github.io/sphinx-bootstrap-theme/README.html"
# Latest version isn't on PyPI
# https://github.com/ryan-roemer/sphinx-bootstrap-theme/issues/210
SRC_URI="
	https://github.com/ryan-roemer/${PN}/archive/${MY_COMMIT}.tar.gz
		-> ${PN}-${MY_COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="<dev-python/setuptools-58[${PYTHON_USEDEP}]"

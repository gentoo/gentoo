# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python implementation of the Varlink protocol"
HOMEPAGE="
	https://github.com/varlink/python/
	https://pypi.org/project/varlink/
"
SRC_URI="
	https://github.com/varlink/python/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/python-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

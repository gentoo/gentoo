# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Signs JSON objects with ED25519 signatures."
HOMEPAGE="
	https://github.com/matrix-org/python-signedjson/
	https://pypi.org/project/signedjson/
"
SRC_URI="https://github.com/matrix-org/python-signedjson/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

S="${WORKDIR}/python-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64"

RDEPEND="
	dev-python/canonicaljson[${PYTHON_USEDEP}]
	dev-python/pynacl[${PYTHON_USEDEP}]
	dev-python/unpaddedbase64[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/importlib_metadata[${PYTHON_USEDEP}]
	' python3_9)
"

distutils_enable_tests unittest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

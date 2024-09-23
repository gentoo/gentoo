# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{6..13} )

inherit distutils-r1

MY_P=kas-${PV}
DESCRIPTION="Setup tool for bitbake based projects."
HOMEPAGE="https://kas.readthedocs.io/en/latest/"
SRC_URI="
	https://github.com/siemens/kas/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pyyaml-3.0.0
	>=dev-python/distro-1.0.0
	>=dev-python/jsonschema-2.5.0
	>=dev-python/kconfiglib-14.1.0
	>=dev-python/GitPython-3.1.0
"

distutils_enable_tests pytest

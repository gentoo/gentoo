# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

# TODO: rename when the old version is gone?
MY_P=python-${P}
DESCRIPTION="Unified diff parsing/metadata extraction library"
HOMEPAGE="
	https://github.com/matiasb/python-unidiff/
	https://pypi.org/project/unidiff/
"
SRC_URI="
	https://github.com/matiasb/python-unidiff/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

distutils_enable_tests unittest

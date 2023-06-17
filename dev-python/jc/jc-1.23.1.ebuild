# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Converts the output of popular command-line tools and file-types to JSON"
HOMEPAGE="
	https://github.com/kellyjonbrazil/jc/
	https://pypi.org/project/jc/
"
SRC_URI="
	https://github.com/kellyjonbrazil/jc/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

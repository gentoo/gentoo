# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python Levenshtein implementation"
HOMEPAGE="
	https://github.com/toastdriven/pylev/
	https://pypi.org/project/pylev/
"
SRC_URI="
	https://github.com/toastdriven/pylev/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"

distutils_enable_tests unittest

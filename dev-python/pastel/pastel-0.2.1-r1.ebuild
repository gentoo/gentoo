# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Bring colors to your terminal"
HOMEPAGE="
	https://github.com/sdispater/pastel/
	https://pypi.org/project/pastel/
"
SRC_URI="
	https://github.com/sdispater/pastel/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~x86"

distutils_enable_tests pytest

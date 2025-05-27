# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Bringing the elegance of C# EventHandler to Python"
HOMEPAGE="
	https://pypi.org/project/Events/
	https://github.com/pyeve/events/
"
# No sdist in pypi as of PV=0.5
SRC_URI="
	https://github.com/pyeve/events/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests unittest

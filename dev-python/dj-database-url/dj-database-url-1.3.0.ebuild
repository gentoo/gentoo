# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Use Database URLs in your Django Application"
HOMEPAGE="
	https://github.com/jazzband/dj-database-url/
	https://pypi.org/project/dj-database-url/
"
# tests are missing in sdist as of 1.3.0
# https://github.com/jazzband/dj-database-url/pull/213
SRC_URI="
	https://github.com/jazzband/dj-database-url/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.10.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

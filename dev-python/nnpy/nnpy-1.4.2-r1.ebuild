# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="cffi-based Python bindings for nanomsg"
HOMEPAGE="
	https://github.com/nanomsg/nnpy/
	https://pypi.org/project/nnpy/
"
SRC_URI="
	https://github.com/nanomsg/nnpy/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"

DEPEND="
	dev-python/cffi:=[${PYTHON_USEDEP}]
	dev-libs/nanomsg:=
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests unittest

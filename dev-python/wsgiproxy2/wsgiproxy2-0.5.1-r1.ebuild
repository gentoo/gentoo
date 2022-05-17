# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_PN="WSGIProxy2"
DESCRIPTION="HTTP proxying tools for WSGI apps"
HOMEPAGE="
	https://github.com/gawel/WSGIProxy2/
	https://pypi.org/project/WSGIProxy2/
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/webob[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/webtest-2.0.17[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests unittest

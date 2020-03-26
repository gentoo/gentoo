# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="A pure-Python WSGI server"
HOMEPAGE="https://docs.pylonsproject.org/projects/waitress/en/latest/
	https://pypi.org/project/waitress/
	https://github.com/Pylons/waitress"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ia64 ppc ppc64 s390 sparc x86"

distutils_enable_tests nose

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} pypy3  )

inherit distutils-r1

DESCRIPTION="Makes working with XML feel like you are working with JSON"
HOMEPAGE="https://github.com/martinblech/xmltodict/ https://pypi.org/project/xmltodict/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

distutils_enable_tests nose

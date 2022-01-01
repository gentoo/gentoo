# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="A simple statsd client"
HOMEPAGE="https://github.com/jsocol/pystatsd https://pypi.org/project/statsd"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests nose

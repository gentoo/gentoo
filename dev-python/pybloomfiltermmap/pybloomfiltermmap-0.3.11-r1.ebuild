# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Bloom filter (bloomfilter) for Python built on mmap"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
HOMEPAGE="https://pypi.org/project/pybloomfiltermmap"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

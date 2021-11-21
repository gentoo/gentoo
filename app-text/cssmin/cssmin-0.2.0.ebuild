# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python port of the YUI CSS compression algorithm"
HOMEPAGE="https://pypi.org/project/cssmin/ https://github.com/zacharyvoase/cssmin"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

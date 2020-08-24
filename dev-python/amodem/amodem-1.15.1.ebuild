# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Transmit data between two computers using audio"
HOMEPAGE="https://github.com/romanz/amodem"
SRC_URI="https://github.com/romanz/amodem/archive/v${PV}.tar.gz -> ${P}.tar.gz
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest

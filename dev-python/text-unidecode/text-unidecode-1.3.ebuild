# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} pypy{,3} )

inherit distutils-r1

DESCRIPTION="text-unidecode is the most basic Python port of the Text::Unidecode Perl library"
HOMEPAGE="https://github.com/kmike/text-unidecode"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="|| ( GPL-2+ Artistic )"
SLOT="0"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

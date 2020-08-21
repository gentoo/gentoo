# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="Tthe most basic port of the Text::Unidecode Perl library"
HOMEPAGE="
	https://pypi.org/project/text-unidecode/
	https://github.com/kmike/text-unidecode/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2+ )"
SLOT="0"
KEYWORDS="~amd64 x86"

distutils_enable_tests pytest

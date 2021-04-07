# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Filters for web typography, supporting Django & Jinja templates"
HOMEPAGE="https://github.com/mintchaos/typogrify/ https://pypi.org/project/typogrify/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/smartypants[${PYTHON_USEDEP}]')
"

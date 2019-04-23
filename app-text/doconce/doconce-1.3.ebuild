# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_5 )
inherit distutils-r1

DESCRIPTION="A markdown-like langauge to generate docs in html, LaTeX, and many other formats"
HOMEPAGE="https://github.com/hplgit/doconce/ https://pypi.org/project/doconce/"
SRC_URI="https://dev.gentoo.org/~grozin/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"
DEPEND="dev-python/future"
RDEPEND="${DEPEND}"

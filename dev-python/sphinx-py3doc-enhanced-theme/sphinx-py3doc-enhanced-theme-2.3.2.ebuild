# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} pypy3 )

inherit distutils-r1

DESCRIPTION="Enhanced Sphinx theme (based on Python 3 docs)"
HOMEPAGE="https://github.com/ionelmc/sphinx-py3doc-enhanced-theme https://pypi.org/project/sphinx-py3doc-enhanced-theme/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

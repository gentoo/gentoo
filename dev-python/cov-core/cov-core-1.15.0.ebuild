# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} pypy pypy3 )
inherit distutils-r1

DESCRIPTION="plugin core for use by pytest-cov, nose-cov and nose2-cov"
HOMEPAGE="https://bitbucket.org/memedough/cov-core/overview"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ia64 m68k ppc ppc64 s390 sh ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-python/coverage-3.6[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )
PYTHON_REQ_USE="wide-unicode(+)"
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1

MY_P=Unidecode-${PV}
DESCRIPTION="Module providing ASCII transliterations of Unicode text"
HOMEPAGE="https://pypi.org/project/Unidecode/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${PN^}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 sparc x86"

distutils_enable_tests setup.py

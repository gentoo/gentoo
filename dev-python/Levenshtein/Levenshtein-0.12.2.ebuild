# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

MY_PN="python-Levenshtein"
MY_P="${MY_PN}-${PV}"
inherit distutils-r1

DESCRIPTION="Functions for fast computation of Levenshtein distance, and edit operations"
HOMEPAGE="https://pypi.org/project/python-Levenshtein/
	https://github.com/ztane/python-Levenshtein/"
SRC_URI="mirror://pypi/${MY_PN::1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

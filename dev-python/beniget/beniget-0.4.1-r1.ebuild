# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Extract semantic information about static Python code"
HOMEPAGE="
	https://pypi.org/project/beniget/
	https://github.com/serge-sans-paille/beniget/"
SRC_URI="
	https://github.com/serge-sans-paille/beniget/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="=dev-python/gast-0.5*[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py

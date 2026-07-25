# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..15} )
inherit distutils-r1

DESCRIPTION="wow very terminal doge"
HOMEPAGE="https://github.com/Olivia5k/doge/"
# formerly used pypi.eclass but, last time checked, 3.9.2 has not made
# it there and the github repo been archived right after the release
SRC_URI="
	https://github.com/Olivia5k/doge/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/fullmoon[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	')
	sys-process/procps
"

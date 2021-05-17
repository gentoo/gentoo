# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Python module import analysis tool"
HOMEPAGE="https://github.com/mgedmin/findimports"
SRC_URI="
	https://github.com/mgedmin/findimports/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests setup.py

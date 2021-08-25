# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_P="svg.path-${PV}"
DESCRIPTION="SVG path objects and parser"
HOMEPAGE="https://github.com/regebro/svg.path"
SRC_URI="
	https://github.com/regebro/svg.path/archive/${PV}.tar.gz
		-> ${MY_P}.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests setup.py

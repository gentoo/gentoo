# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=urwid_readline-${PV}
DESCRIPTION="Text input widget for urwid that supports readline shortcuts"
HOMEPAGE="
	https://github.com/rr-/urwid_readline/
	https://pypi.org/project/urwid-readline/
"
SRC_URI="
	https://github.com/rr-/urwid_readline/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/urwid[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

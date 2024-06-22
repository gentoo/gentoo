# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Node.js virtual environment builder"
HOMEPAGE="
	https://github.com/ekalinin/nodeenv/
	https://pypi.org/project/nodeenv/
"
SRC_URI="
	https://github.com/ekalinin/nodeenv/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 arm64 ~hppa ~ppc ~ppc64 ~x86"

# requires network access
RESTRICT="test"
PROPERTIES="test_network"

PATCHES=(
	# https://github.com/ekalinin/nodeenv/pull/355
	"${FILESDIR}/${PN}-1.9.0-which-hunt.patch"
)

distutils_enable_tests pytest

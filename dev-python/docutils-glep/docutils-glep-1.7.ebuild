# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Gentoo GLEP support for docutils"
HOMEPAGE="
	https://github.com/projg2/docutils-glep/
	https://pypi.org/project/docutils-glep/
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-python/docutils-0.10[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests import-check

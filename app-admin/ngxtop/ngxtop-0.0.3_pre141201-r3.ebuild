# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="real-time metrics for nginx server (and others)"
HOMEPAGE="https://github.com/lebinh/ngxtop"
#SRC_URI="https://github.com/lebinh/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-0.0.2-py3.patch )

distutils_enable_tests pytest

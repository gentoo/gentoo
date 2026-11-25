# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MY_P="${PN}-rel-${PV}"
DESCRIPTION="A Python module to deal with freedesktop.org specifications"
HOMEPAGE="
	https://freedesktop.org/wiki/Software/pyxdg/
	https://pypi.org/project/pyxdg/
"
SRC_URI="
	https://github.com/takluyver/pyxdg/archive/rel-${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.28-py3.12.patch
	"${FILESDIR}"/${PN}-0.28-py3.14.patch
	"${FILESDIR}"/${PN}-0.28-shared-mine-info-2.5.patch
)

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

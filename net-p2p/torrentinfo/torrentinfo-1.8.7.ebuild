# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A torrent file parser"
HOMEPAGE="https://github.com/Fuuzetsu/torrentinfo"
SRC_URI="https://github.com/Fuuzetsu/torrentinfo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	# https://github.com/Fuuzetsu/torrentinfo/pull/16
	"${FILESDIR}/${PN}-1.8.6-fix-tests.patch"
	# https://github.com/Fuuzetsu/torrentinfo/pull/18
	"${FILESDIR}/${PN}-1.8.6-remove-nose.patch"
)

distutils_enable_tests pytest

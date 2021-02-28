# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="A module for (de)serialization to and from VDF, Valve's key-value text format"
HOMEPAGE="https://github.com/ValvePython/vdf"
SRC_URI="https://codeload.github.com/ValvePython/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2-mock_from_stdlib.patch
)

distutils_enable_tests pytest

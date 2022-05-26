# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="A module for (de)serialization to and from VDF, Valve's key-value text format"
HOMEPAGE="https://github.com/ValvePython/vdf"
SRC_URI="https://codeload.github.com/ValvePython/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

distutils_enable_tests pytest

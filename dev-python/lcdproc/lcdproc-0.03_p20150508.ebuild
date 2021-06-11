# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="973628fc326177c9deaf3f2e1a435159eb565ae0"
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python OOP wrapper library for LCDproc Telnet API"
HOMEPAGE="https://github.com/jinglemansweep/lcdproc"
SRC_URI="https://github.com/jinglemansweep/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-misc/lcdproc"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

DOCS=( "README.textile" "examples.py" )

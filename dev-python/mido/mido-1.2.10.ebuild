# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="MIDI Objects, a library for working with MIDI messages and ports"
HOMEPAGE="
	https://pypi.org/project/mido/
	https://github.com/mido/mido
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+portmidi rtmidi"

RDEPEND="portmidi? ( media-libs/portmidi )
	rtmidi? ( dev-python/python-rtmidi[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs
distutils_enable_tests pytest

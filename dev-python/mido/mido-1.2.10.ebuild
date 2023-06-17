# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="MIDI Objects, a library for working with MIDI messages and ports"
HOMEPAGE="
	https://pypi.org/project/mido/
	https://github.com/mido/mido
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+portmidi rtmidi"

RDEPEND="portmidi? ( media-libs/portmidi )
	rtmidi? ( dev-python/python-rtmidi[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs
distutils_enable_tests pytest

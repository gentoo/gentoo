# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

DESCRIPTION="CLI and curses mixer for PulseAudio"
HOMEPAGE="https://github.com/GeorgeFilipkin/pulsemixer"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/GeorgeFilipkin/${PN}"
else
	SRC_URI="https://github.com/GeorgeFilipkin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="media-sound/pulseaudio"

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/patroclos/PAmix.git"
	inherit git-r3
else
	SRC_URI="https://github.com/patroclos/PAmix/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/PAmix-${PV}"
fi

DESCRIPTION="PulseAudio NCurses mixer"
HOMEPAGE="https://github.com/patroclos/PAmix"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	media-libs/libpulse
	sys-libs/ncurses:=[unicode(+)]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

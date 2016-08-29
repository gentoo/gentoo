# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

[[ "${PV}" == 9999 ]] && inherit git-r3

DESCRIPTION="A PulseAudio NCurses mixer"
HOMEPAGE="https://github.com/patroclos/PAmix"
LICENSE="MIT"
SLOT="0"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="git://github.com/patroclos/PAmix.git"
else
	SRC_URI="https://github.com/patroclos/PAmix/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/PAmix-${PV}"
fi

RDEPEND="media-sound/pulseaudio
	sys-libs/ncurses:0=[unicode]"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

src_unpack() {
	[[ "${PV}" == 9999 ]] && git-r3_src_unpack
	default
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

SCM=""
[[ "${PV}" == 9999 ]] && SCM="git-r3"
inherit autotools ${SCM}
unset SCM

DESCRIPTION="A PulseAudio NCurses mixer"
HOMEPAGE="https://github.com/patroclos/PAmix"
LICENSE="MIT"
SLOT="0"
IUSE="+unicode"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="git://github.com/patroclos/PAmix.git"
else
	SRC_URI="https://github.com/patroclos/PAmix/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/PAmix-${PV}"
fi

RDEPEND="media-sound/pulseaudio
	sys-libs/ncurses:0=[unicode?]"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable unicode)
}

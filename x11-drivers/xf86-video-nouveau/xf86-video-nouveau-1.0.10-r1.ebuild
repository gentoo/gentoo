# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
XORG_DRI="always"
inherit xorg-2

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/nouveau/${PN}"
	SRC_URI=""
fi

DESCRIPTION="Accelerated Open Source driver for nVidia cards"
HOMEPAGE="http://nouveau.freedesktop.org/"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="udev"

RDEPEND="udev? ( virtual/udev )
	>=x11-libs/libdrm-2.4.34[video_cards_nouveau]"
DEPEND="${RDEPEND}"

src_prepare() {
	xorg-2_src_prepare

	# There is no configure knob for this, so hack it.
	use udev || export LIBUDEV_{CFLAGS,LIBS}=' '
	sed -i \
		-e "/LIBUDEV=/s:=.*:=$(usex udev):" \
		configure || die
}

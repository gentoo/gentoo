# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: figure out htf to make python.eclass work

EAPI="5"

inherit eutils multilib
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://urjtag.git.sourceforge.net/gitroot/urjtag/urjtag"
	inherit git-r3 autotools
	S=${WORKDIR}/${P}/${PN}
else
	SRC_URI="mirror://sourceforge/urjtag/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~sparc ~x86"
fi

DESCRIPTION="tool for communicating over JTAG with flash chips, CPUs, and many more (fork of openwince jtag)"
HOMEPAGE="http://urjtag.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="ftdi readline usb"

DEPEND="ftdi? ( dev-embedded/libftdi:0 )
	readline? ( sys-libs/readline:= )
	usb? ( virtual/libusb:0 )"
RDEPEND="${DEPEND}
	!dev-embedded/jtag"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		mkdir -p m4
		eautopoint
		eautoreconf
	fi
}

src_configure() {
	use readline || export vl_cv_lib_readline=no

	econf \
		--disable-werror \
		--disable-python \
		$(use_with ftdi libftdi) \
		$(use_with usb libusb)
}

src_install() {
	default
	prune_libtool_files
}

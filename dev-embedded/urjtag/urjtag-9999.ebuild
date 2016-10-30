# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: figure out htf to make python.eclass work

EAPI="5"

inherit eutils multilib
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.code.sf.net/p/urjtag/git"
	inherit git-r3 autotools
	S=${WORKDIR}/${P}/${PN}
else
	SRC_URI="mirror://sourceforge/urjtag/${P}.tar.bz2"
	KEYWORDS="amd64 ppc sparc x86"
fi

DESCRIPTION="tool for communicating over JTAG with flash chips, CPUs, and many more (fork of openwince jtag)"
HOMEPAGE="http://urjtag.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="ftd2xx ftdi readline static-libs usb"

DEPEND="ftdi? ( dev-embedded/libftdi:= )
	ftd2xx? ( dev-embedded/libftd2xx )
	readline? ( sys-libs/readline:= )
	usb? ( virtual/libusb:1 )"
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
	use ftd2xx && LDFLAGS="${LDFLAGS} -L/opt/$(get_libdir)"

	econf \
		--disable-werror \
		--disable-python \
		$(use_with readline) \
		$(use_with ftdi libftdi) \
		$(use_with ftd2xx) \
		$(use_enable static-libs static) \
		$(use_with usb libusb 1.0)
}

src_install() {
	default
	prune_libtool_files
}

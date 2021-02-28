# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.code.sf.net/p/urjtag/git"
	inherit git-r3 autotools
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="mirror://sourceforge/urjtag/${P}.tar.xz"
	KEYWORDS="amd64 ppc sparc x86"
fi

DESCRIPTION="Tool for communicating over JTAG with flash chips, CPUs, and many more"
HOMEPAGE="http://urjtag.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
# TODO: Figure out if anyone wants the Python bindings
IUSE="ftdi ftd2xx readline usb"

DEPEND="ftdi? ( dev-embedded/libftdi:1= )
	ftd2xx? ( dev-embedded/libftd2xx )
	readline? ( sys-libs/readline:= )
	usb? ( virtual/libusb:1 )"
RDEPEND="${DEPEND}
	!dev-embedded/jtag"

src_prepare() {
	default

	if [[ ${PV} == "9999" ]] ; then
		mkdir -p m4 || die
		eautopoint
		eautoreconf
	fi
}

src_configure() {
	econf \
		--disable-werror \
		--disable-python \
		--disable-static \
		$(use_with readline) \
		$(use_with ftdi libftdi) \
		$(use_with ftd2xx) \
		$(use_with usb libusb 1.0)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

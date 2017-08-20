# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="Tool for communicating over JTAG with flash chips, CPUs, and many more"
HOMEPAGE="http://urjtag.sourceforge.net/"
SRC_URI="mirror://sourceforge/urjtag/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="ftdi readline"

DEPEND="!dev-embedded/jtag
	ftdi? ( =dev-embedded/libftdi-0* )
	readline? ( sys-libs/readline )"

src_compile() {
	use readline || export vl_cv_lib_readline=no
	econf $(use_enable ftdi libftdi) || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "failed to install"
	dodoc AUTHORS ChangeLog NEWS README THANKS
}

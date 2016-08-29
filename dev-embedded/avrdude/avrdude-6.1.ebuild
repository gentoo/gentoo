# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="AVR Downloader/UploaDEr"
HOMEPAGE="https://savannah.nongnu.org/projects/avrdude"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz
	doc? (
		mirror://nongnu/${PN}/${PN}-doc-${PV}.tar.gz
		mirror://nongnu/${PN}/${PN}-doc-${PV}.pdf
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc ftdi ncurses readline"

RDEPEND="virtual/libusb:1
	virtual/libusb:0
	ftdi? ( dev-embedded/libftdi:= )
	ncurses? ( sys-libs/ncurses:= )
	readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog* NEWS README"

src_prepare() {
	# let the build system re-generate these, bug #120194
	rm -f lexer.c config_gram.c config_gram.h || die
}

src_configure() {
	# somehow this doesnt get set when cross-compiling and breaks build
	tc-export AR
	export ac_cv_lib_ftdi_ftdi_usb_get_strings=$(usex ftdi)
	export ac_cv_lib_ncurses_tputs=$(usex ncurses)
	export ac_cv_lib_readline_readline=$(usex readline)
	default
}

src_compile() {
	# The automake target for these files does not use tempfiles or create
	# these atomically, confusing a parallel build. So we force them first.
	emake lexer.c config_gram.c config_gram.h
	emake
}

src_install() {
	default

	if use doc ; then
		newdoc "${DISTDIR}/${PN}-doc-${PV}.pdf" avrdude.pdf
		dohtml -r "${WORKDIR}/avrdude-html/"
	fi
}

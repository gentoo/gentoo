# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A fully open source driver which supports all DisplayLink devices"
HOMEPAGE="https://libdlo.freedesktop.org/wiki/"
SRC_URI="https://people.freedesktop.org/~berniet/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="static-libs test-program"

RDEPEND="virtual/libusb:0="
DEPEND="${RDEPEND}"

DOCS=( "AUTHORS" "ChangeLog" "Guide-v104.pdf" "README" )

src_prepare() {
	default

	# AM_PROG_AR must be defined or automake will fail with:
	# archiver requires 'AM_PROG_AR' in 'configure.ac'.
	sed -i -e '/AC_PROG_CC/a AM_PROG_AR' configure.ac || die

	# Only build the Displaylink test program, if a user wants it.
	if ! use test-program; then
		eapply "${FILESDIR}"/disable-testprogram.patch
	fi

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	# Rename the Displaylink test program to an useful name
	if use test-program; then
		mv "${D}"/usr/bin/test1 "${D}"/usr/bin/displaylink-test || die
	fi

	find "${D}" -name '*.la' -delete || die
}

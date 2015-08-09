# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit flag-o-matic

DESCRIPTION="A full featured backup tool, aimed for disks (floppy,CDR(W),DVDR(W),zip,jazz etc.)"
HOMEPAGE="http://dar.linux.free.fr/"
SRC_URI="mirror://sourceforge/dar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="acl dar32 dar64 doc nls ssl"

RDEPEND=">=sys-libs/zlib-1.2.3
	>=app-arch/bzip2-1.0.2
	acl? ( sys-apps/attr )
	nls? ( virtual/libintl )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )"

pkg_setup() {
	if use dar32 && use dar64 ; then
		eerror "dar32 and dar64 cannot be enabled together."
		eerror "Please remove one of them and try the emerge again."
		die "Please remove dar32 or dar64."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e '/^dist_noinst_DATA/s/$/ macro_tools.hpp/' \
		-e '/^noinst_HEADERS/s/macro_tools.hpp//' \
		src/libdar/Makefile* || die
}

src_compile() {
	local myconf="--disable-upx"

	# Bug 103741
	filter-flags -fomit-frame-pointer

	use acl || myconf="${myconf} --disable-ea-support"
	use dar32 && myconf="${myconf} --enable-mode=32"
	use dar64 && myconf="${myconf} --enable-mode=64"
	use doc || myconf="${myconf} --disable-build-html"
	# use examples && myconf="${myconf} --enable-examples"
	use nls || myconf="${myconf} --disable-nls"
	use ssl || myconf="${myconf} --disable-libcrypto-linking"

	econf ${myconf} || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" pkgdatadir=/usr/share/doc/${PF}/html install || die

	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}

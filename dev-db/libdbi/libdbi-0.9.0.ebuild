# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A database-independent abstraction layer in C"
HOMEPAGE="http://libdbi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="doc static-libs"

DOCS=( AUTHORS ChangeLog README README.osx TODO )

BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/openjade )
"
PDEPEND=">=dev-db/libdbi-drivers-0.9.0" # On purpose, libdbi-drivers 0.8.4 does not exist

src_prepare() {
	eapply "${FILESDIR}"/libdbi-0.9.0-doc-build-fix.patch

	mv configure.in configure.ac || die

	# configure.in/ac has been changed
	eautoreconf

	# should append CFLAGS, not replace them
	sed -i.orig -e 's/^CFLAGS = /CFLAGS += /g' src/Makefile.in
	eapply_user
}

src_configure() {
	econf \
		$(use_enable doc docs) \
		$(use_enable static-libs static)
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die "removing .la files failed"

	# syslog-ng requires dbi.pc
	insinto /usr/$(get_libdir)/pkgconfig/
	doins dbi.pc
}

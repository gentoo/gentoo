# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils autotools ltprune multilib

DESCRIPTION="A database-independent abstraction layer in C"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://libdbi.sourceforge.net/"
LICENSE="LGPL-2.1"

IUSE="doc static-libs"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
SLOT=0

DOCS="AUTHORS ChangeLog README README.osx TODO"

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	virtual/pkgconfig
	doc? ( app-text/openjade )
"
PDEPEND=">=dev-db/libdbi-drivers-0.9.0" # On purpose, libdbi-drivers 0.8.4 does not exist

src_unpack() {
	unpack ${A}
	chown -R portage:portage "${S}"
}

src_prepare() {
	#epatch "${FILESDIR}"/${PN}-0.9.0-fix-ac-macro.patch
	#epatch "${FILESDIR}"/libdbi-0.8.1-pkg-config.patch
	#cp -f "${FILESDIR}"/dbi.pc.in "${S}"/dbi.pc.in
	epatch "${FILESDIR}"/libdbi-0.9.0-doc-build-fix.patch

	# configure.in has been changed
	eautoreconf
	# should append CFLAGS, not replace them
	sed -i.orig -e 's/^CFLAGS = /CFLAGS += /g' src/Makefile.in
}

src_configure() {
	econf \
		$(use_enable doc docs) \
		$(use_enable static-libs static)
}

src_install () {
	default

	prune_libtool_files --all

	# syslog-ng requires dbi.pc
	insinto /usr/$(get_libdir)/pkgconfig/
	doins dbi.pc
}

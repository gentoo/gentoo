# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/wvstreams/wvstreams-4.6.1-r3.ebuild,v 1.9 2013/07/04 12:18:19 ago Exp $

EAPI=5
inherit autotools eutils flag-o-matic toolchain-funcs versionator

DESCRIPTION="A network programming library in C++"
HOMEPAGE="http://alumnit.ca/wiki/?WvStreams"
SRC_URI="http://wvstreams.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE="pam doc +ssl +dbus debug boost"

#Tests fail if openssl is not compiled with -DPURIFY. Gentoo's isn't. FAIL!
RESTRICT="test"

#QA Fail: xplc is compiled as a part of wvstreams.
#It'll take a larger patching effort to get it extracted, since upstream integrated it
#more tightly this time. Probably for the better since upstream xplc seems dead.

RDEPEND="sys-libs/readline
	sys-libs/zlib
	dbus? ( >=sys-apps/dbus-1.4.20 )
	dev-libs/openssl:0
	pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	boost? ( >=dev-libs/boost-1.34.1:= )"

DOCS="ChangeLog README*"

pkg_pretend() {
	[[ ${MERGE_TYPE} == "binary" ]] && return

	if ! use boost && ! version_is_at_least 4.1 "$(gcc-fullversion)"; then
		eerror "This package requires the active gcc to be at least version 4.1"
		eerror "or USE=boost must be installed."
		die "Please activate >=sys-devel/gcc-4.1 with gcc-config."
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-parallel-make.patch \
		"${FILESDIR}"/${P}-openssl-1.0.0.patch \
		"${FILESDIR}"/${P}-glibc212.patch \
		"${FILESDIR}"/${P}-gcc47.patch

	sed -i \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e 's:AM_PROG_CC_STDC:AC_PROG_CC:' \
		configure.ac argp/configure.ac || die

	eautoreconf
	pushd argp >/dev/null
	eautoreconf
	popd >/dev/null
}

src_configure() {
	append-flags -fno-strict-aliasing
	append-flags -fno-tree-dce -fno-optimize-sibling-calls #421375

	tc-export AR CXX

	use boost && export ac_cv_header_tr1_functional=no

	econf \
		--localstatedir=/var \
		$(use_enable debug) \
		--disable-optimization \
		$(use_with dbus) \
		--with-openssl \
		$(use_with pam) \
		--without-tcl \
		--without-qt \
		--with-zlib \
		--without-valgrind
}

src_compile() {
	default

	if use doc; then
		doxygen || die
	fi
}

src_test() {
	emake test
}

src_install() {
	default

	if use doc; then
		#the list of files is too big for dohtml -r Docs/doxy-html/*
		cd Docs/doxy-html
		dohtml -r *
	fi
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="A network programming library in C++"
HOMEPAGE="https://github.com/apenwarr/wvstreams"
SRC_URI="
	mirror://debian/pool/main/w/${PN}/${PN}_${PV/_p*}.orig.tar.gz
	mirror://debian/pool/main/w/${PN}/${PN}_${PV/_p/-}.debian.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE="boost +dbus debug doc libressl pam"

#Tests fail if openssl is not compiled with -DPURIFY. Gentoo's isn't. FAIL!
RESTRICT="test"

#QA Fail: xplc is compiled as a part of wvstreams.
#It'll take a larger patching effort to get it extracted, since upstream integrated it
#more tightly this time. Probably for the better since upstream xplc seems dead.

RDEPEND="
	sys-libs/readline:0=
	sys-libs/zlib
	dbus? ( >=sys-apps/dbus-1.4.20 )
	!libressl? ( >=dev-libs/openssl-1.1:0= )
	libressl? ( dev-libs/libressl:0= )
	pam? ( sys-libs/pam )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	boost? ( >=dev-libs/boost-1.34.1:= )
"
DOCS="ChangeLog README*"
PATCHES=(
	"${FILESDIR}"/${PN}-4.6.1-autoconf.patch
	"${FILESDIR}"/${PN}-4.6.1-gcc47.patch
	"${FILESDIR}"/${PN}-4.6.1-parallel-make.patch
	"${FILESDIR}"/${PN}-4.6.1-_DEFAULT_SOURCE.patch
)
S=${WORKDIR}/${P/_p*}

src_prepare() {
	default

	eapply $(awk '{ print "'"${WORKDIR}"'/debian/patches/" $0; }' < "${WORKDIR}"/debian/patches/series)
	eapply "${FILESDIR}"/${P}-libressl.patch # bug 687096

	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing
	append-flags -fno-tree-dce -fno-optimize-sibling-calls #421375

	tc-export AR CXX

	use boost && export ac_cv_header_tr1_functional=no

	econf \
		$(use_enable debug) \
		$(use_with dbus) \
		$(use_with pam) \
		--cache-file="${T}"/config.cache \
		--disable-optimization \
		--localstatedir=/var \
		--with-openssl \
		--with-zlib \
		--without-qt \
		--without-tcl \
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
		docinto html
		dodoc -r Docs/doxy-html/*
	fi
}

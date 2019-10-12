# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils flag-o-matic toolchain-funcs versionator

DESCRIPTION="A network programming library in C++"
HOMEPAGE="http://alumnit.ca/wiki/?WvStreams"
SRC_URI="https://wvstreams.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="pam doc +ssl +dbus debug boost"

#Tests fail if openssl is not compiled with -DPURIFY. Gentoo's isn't. FAIL!
RESTRICT="test"

#QA Fail: xplc is compiled as a part of wvstreams.
#It'll take a larger patching effort to get it extracted, since upstream integrated it
#more tightly this time. Probably for the better since upstream xplc seems dead.

RDEPEND="
	<dev-libs/openssl-1.1:0=
	sys-libs/readline:0=
	sys-libs/zlib
	dbus? ( >=sys-apps/dbus-1.4.20 )
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
	"${FILESDIR}"/${P}-autoconf.patch
	"${FILESDIR}"/${P}-fix-c++14.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-glibc212.patch
	"${FILESDIR}"/${P}-openssl-1.0.0.patch
	"${FILESDIR}"/${P}-parallel-make.patch
	"${FILESDIR}"/${P}-_DEFAULT_SOURCE.patch
)

src_prepare() {
	default

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
		#the list of files is too big for dohtml -r Docs/doxy-html/*
		docinto html
		dodoc -r Docs/doxy-html/*
	fi
}

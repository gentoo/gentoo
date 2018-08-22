# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="suite of small networking utilities for Unix systems"
HOMEPAGE="https://www.skarnet.org/software/s6-networking/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~x86"
IUSE="ssl static static-libs"

REQUIRED_USE="static? ( static-libs )"

DEPEND=">=dev-lang/execline-2.5.0.1[static-libs?]
	>=sys-apps/s6-2.7.2.0[static-libs?]
	>=net-dns/s6-dns-2.3.0.1[static-libs?]
	>=dev-libs/skalibs-2.7.0.0[static-libs?]
	ssl? ( >=dev-libs/libressl-2.6.5[static-libs?] )
"
RDEPEND=">=dev-lang/execline-2.5.0.1:=
	>=sys-apps/s6-2.7.2.0:=
	!static? (
		>=net-dns/s6-dns-2.3.0.1:=
		>=dev-libs/skalibs-2.7.0.0:=
		ssl? ( >=dev-libs/libressl-2.6.5:= )
	)
"

HTML_DOCS="doc/*"

src_prepare() {
	default

	# Remove QA warning about LDFLAGS addition
	sed -i "s/tryldflag LDFLAGS_AUTO -Wl,--hash-style=both/:/" "${S}/configure" || die

	# configure overrides gentoo's -fstack-protector default
	sed -i "/^tryflag CFLAGS_AUTO -fno-stack-protector$/d" "${S}/configure" || die
}

src_configure() {
	econf \
		--bindir=/bin \
		--dynlibdir=/$(get_libdir) \
		--libdir=/usr/$(get_libdir)/${PN} \
		--with-dynlib=/$(get_libdir) \
		--with-lib=/usr/$(get_libdir)/s6 \
		--with-lib=/usr/$(get_libdir)/s6-dns \
		--with-lib=/usr/$(get_libdir)/skalibs \
		--with-sysdeps=/usr/$(get_libdir)/skalibs \
		--enable-shared \
		$(use_enable ssl ssl libressl) \
		$(use_enable static allstatic) \
		$(use_enable static static-libc) \
		$(use_enable static-libs static)
}

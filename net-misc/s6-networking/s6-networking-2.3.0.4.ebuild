# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Suite of small networking utilities for Unix systems"
HOMEPAGE="https://www.skarnet.org/software/s6-networking/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~x86"
IUSE="ssl static static-libs"

REQUIRED_USE="static? ( static-libs )"

RDEPEND=">=dev-lang/execline-2.5.1.0:=[static-libs?]
	>=dev-libs/skalibs-2.8.0.0:=[static-libs?]
	>=sys-apps/s6-2.8.0.0:=[static-libs?]
	!static? (
		>=net-dns/s6-dns-2.3.0.2:=
		ssl? ( >=dev-libs/libressl-2.7.4:= )
	)
"
DEPEND="${RDEPEND}
	>=net-dns/s6-dns-2.3.0.2[static-libs?]
	ssl? ( >=dev-libs/libressl-2.7.4[static-libs?] )
"

HTML_DOCS=( doc/. )

src_prepare() {
	default

	# Avoid QA warning for LDFLAGS addition; avoid overriding -fstack-protector
	sed -i -e 's/.*-Wl,--hash-style=both$/:/' -e '/-fno-stack-protector$/d' \
		configure || die
}

src_configure() {
	econf \
		--bindir=/bin \
		--dynlibdir=/usr/$(get_libdir) \
		--libdir=/usr/$(get_libdir)/${PN} \
		--with-dynlib=/usr/$(get_libdir) \
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

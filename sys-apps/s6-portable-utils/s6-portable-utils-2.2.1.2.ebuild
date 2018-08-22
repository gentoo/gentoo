# Copyright 1999-2017 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="set of tiny portable unix utilities"
HOMEPAGE="https://www.skarnet.org/software/s6-portable-utils/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

DEPEND="static? ( >=dev-libs/skalibs-2.7.0.0[static-libs] )
	!static? ( >=dev-libs/skalibs-2.7.0.0 )
"
RDEPEND="!static? ( >=dev-libs/skalibs-2.7.0.0:= )"

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
		--with-lib=/usr/$(get_libdir)/skalibs \
		--with-sysdeps=/usr/$(get_libdir)/skalibs \
		$(use_enable static allstatic) \
		$(use_enable static static-libc)
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Set of tiny portable unix utilities"
HOMEPAGE="https://www.skarnet.org/software/s6-portable-utils/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

RDEPEND="!static? ( >=dev-libs/skalibs-2.9.1.0:= )"
DEPEND="${RDEPEND}
	static? ( >=dev-libs/skalibs-2.9.1.0[static-libs] )
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
		--with-dynlib=/$(get_libdir) \
		--with-lib=/usr/$(get_libdir) \
		--with-sysdeps=/usr/$(get_libdir)/skalibs/sysdeps \
		$(use_enable static allstatic) \
		$(use_enable static static-libc)
}

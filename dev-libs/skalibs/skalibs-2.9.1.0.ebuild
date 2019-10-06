# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit usr-ldscript

DESCRIPTION="General-purpose libraries from skarnet.org"
HOMEPAGE="https://www.skarnet.org/software/skalibs/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc ipv6 static-libs"

RDEPEND=""
DEPEND=""

HTML_DOCS=( doc/. )

src_prepare() {
	default

	# Avoid QA warning for LDFLAGS addition; avoid overriding -fstack-protector
	sed -i -e 's/.*-Wl,--hash-style=both$/:/' -e '/-fno-stack-protector$/d' \
		configure || die
}

src_configure() {
	econf \
		--datadir=/etc \
		--dynlibdir=/$(get_libdir) \
		--libdir=/usr/$(get_libdir) \
		--sysdepdir=/usr/$(get_libdir)/${PN}/sysdeps \
		--with-sysdep-devurandom=yes \
		--enable-clock \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable ipv6)
}

src_install() {
	default

	gen_usr_ldscript libskarnet.so
}

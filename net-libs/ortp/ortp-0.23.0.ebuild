# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/ortp/ortp-0.23.0.ebuild,v 1.5 2015/08/04 12:00:33 zlogene Exp $

EAPI=5

inherit eutils

DESCRIPTION="Open Real-time Transport Protocol (RTP, RFC3550) stack"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="mirror://nongnu/linphone/${PN}/sources/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/9"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug doc examples ipv6 minimal ntp-timestamp ssl srtp zrtp"

RDEPEND="ssl? ( dev-libs/openssl:0= )
	srtp? ( net-libs/libsrtp:0= )
	zrtp? ( >=net-libs/libzrtpcpp-4.0.0:0= )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

REQUIRED_USE="zrtp? ( srtp )"

src_prepare() {
	# ${P} is added after ${docdir}
	if use doc; then
		sed -i -e 's/$(docdir)\/$(PACKAGE)-$(VERSION)/$(docdir)/' Makefile.in \
			|| die "patching Makefile.in failed"
	fi
}

src_configure() {
	local myeconfargs=(
		# memcheck is for HP-UX only
		--disable-memcheck
		# mode64bit adds +DA2.0W +DS2.0 CFLAGS wich are needed for HP-UX
		--disable-mode64bit
		# strict adds -Werror, do not want it
		--disable-strict
		# they seriously failed to understand AC_ARG_ENABLE...
		--disable-tests_enabled
		--enable-fast-install
		--enable-libtool-lock
		# this is fine as long as we do not link to polarssl
		--enable-broken-srtp

		$(use_enable debug)
		$(use_enable ipv6)
		$(use_enable minimal perf)
		$(use_enable ntp-timestamp)
		$(use_enable ssl ssl-hmac)
		$(use_enable zrtp)

		--with-srtp=$(usex srtp "${EPREFIX}"/usr none)
		$(use doc || echo ac_cv_path_DOXYGEN=false)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" pkgdocdir="${EPREFIX}"/usr/share/doc/${PF} \
		install
	dodoc AUTHORS ChangeLog NEWS README TODO

	prune_libtool_files

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins src/tests/*.c
	fi
}

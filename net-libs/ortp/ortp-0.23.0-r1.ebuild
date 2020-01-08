# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Open Real-time Transport Protocol (RTP, RFC3550) stack"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="mirror://nongnu/linphone/${PN}/sources/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/9"
KEYWORDS="alpha amd64 arm64 ia64 ppc ppc64 sparc x86 ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug doc examples ipv6 libressl minimal ntp-timestamp ssl srtp"

RDEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= ) )
	srtp? ( net-libs/libsrtp:0= )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"

src_prepare() {
	default
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
		# zrtp removed from the tree
		--disable-zrtp

		$(use_enable debug)
		$(use_enable ipv6)
		$(use_enable minimal perf)
		$(use_enable ntp-timestamp)
		$(use_enable ssl ssl-hmac)

		--with-srtp=$(usex srtp "${EPREFIX}"/usr none)
		$(use doc || echo ac_cv_path_DOXYGEN=false)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" pkgdocdir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	einstalldocs

	prune_libtool_files

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins src/tests/*.c
	fi
}

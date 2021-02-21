# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs verify-sig

DESCRIPTION="UPnP client library and a simple UPnP client"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz
	verify-sig? ( http://miniupnp.free.fr/files/${P}.tar.gz.sig )"

LICENSE="BSD"
SLOT="0/17"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ppc ppc64 s390 sparc x86"
IUSE="ipv6 kernel_linux static-libs"

RDEPEND=""
BDEPEND="
	kernel_linux? ( sys-apps/lsb-release sys-apps/which )
	verify-sig? ( app-crypt/openpgp-keys-miniupnp )"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/miniupnp.asc

src_prepare() {
	eapply_user

	# These bins are not installed, upnpc-static requires building static lib
	sed -i -e '/EXECUTABLES =/s/ upnpc-static listdevices//' Makefile || die
	# Prevent gzipping manpage.
	sed -i -e '/gzip/d' Makefile || die

	if ! use static-libs; then
		sed -i \
			-e '/FILESTOINSTALL =/s/ $(LIBRARY)//' \
			-e '/$(INSTALL) -m 644 $(LIBRARY) $(DESTDIR)$(INSTALLDIRLIB)/d' \
			Makefile || die
	fi
}

# Upstream cmake causes more trouble than it fixes,
# so we'll just stay with the Makefile for now.

src_compile() {
	tc-export CC AR
	emake upnpc-shared $(usex static-libs upnpc-static '')
}

src_test() {
	emake -j1 HAVE_IPV6=$(usex ipv6) check
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		INSTALLDIRLIB="${EPREFIX}/usr/$(get_libdir)" \
		install

	dodoc README Changelog.txt
}

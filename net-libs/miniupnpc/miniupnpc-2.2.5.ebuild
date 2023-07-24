# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs verify-sig

DESCRIPTION="UPnP client library and a simple UPnP client"
HOMEPAGE="
	http://miniupnp.free.fr/
	https://miniupnp.tuxfamily.org/
	https://github.com/miniupnp/miniupnp/
"
SRC_URI="
	https://miniupnp.tuxfamily.org/files/${P}.tar.gz
	verify-sig? (
		https://miniupnp.tuxfamily.org/files/${P}.tar.gz.sig
	)
"

LICENSE="BSD"
SLOT="0/17"
KEYWORDS="amd64 ~arm arm64 ~hppa ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="ipv6"

BDEPEND="
	kernel_linux? ( sys-apps/lsb-release )
	verify-sig? ( sec-keys/openpgp-keys-miniupnp )
"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/miniupnp.asc

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/miniupnpc-2.2.3-drop-which.patch
	)
	default

	local exprs=(
		# These bins are not installed, upnpc-static requires building static lib
		-e '/EXECUTABLES =/s/ upnpc-static listdevices//'
		# Prevent gzipping manpage.
		-e '/gzip/d'
		# Disable installing the static library
		-e '/FILESTOINSTALL =/s/ $(LIBRARY)//'
		-e '/$(INSTALL) -m 644 $(LIBRARY) $(DESTDIR)$(INSTALLDIRLIB)/d'
	)
	sed -i "${exprs[@]}" Makefile || die
}

# Upstream cmake causes more trouble than it fixes,
# so we'll just stay with the Makefile for now.

src_compile() {
	tc-export CC AR
	emake build/upnpc-shared
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

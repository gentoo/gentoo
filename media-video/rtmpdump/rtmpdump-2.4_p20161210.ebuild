# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit multilib toolchain-funcs multilib-minimal flag-o-matic

DESCRIPTION="RTMP client intended to stream audio or video flash content"
HOMEPAGE="http://rtmpdump.mplayerhq.hu/"
SRC_URI="https://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"

# the library is LGPL-2.1, the command is GPL-2
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 hppa ~mips ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="gnutls ssl libressl"

DEPEND="ssl? (
		gnutls? ( >=net-libs/gnutls-2.12.23-r6[${MULTILIB_USEDEP},nettle(+)] )
		!gnutls? ( !libressl? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] ) libressl? ( dev-libs/libressl ) )
		>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	)"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! use ssl && use gnutls ; then
		ewarn "USE='gnutls' is ignored without USE='ssl'."
		ewarn "Please review the local USE flags for this package."
	fi
}

src_unpack() {
	mkdir -p "${S}" || die "Can't create source directory"
	cd "${S}" || die
	unpack ${A}
}

src_prepare() {
	# fix #571106 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89
	# fix Makefile ( bug #298535 , bug #318353 and bug #324513 )
	sed -i 's/\$(MAKEFLAGS)//g' Makefile \
		|| die "failed to fix Makefile"
	sed -i -e 's:OPT=:&-fPIC :' \
		-e 's:OPT:OPTS:' \
		-e 's:CFLAGS=.*:& $(OPT):' librtmp/Makefile \
		|| die "failed to fix Makefile"
	multilib_copy_sources
	eapply_user
}

multilib_src_compile() {
	if use ssl ; then
		if use gnutls ;	then
			crypto="GNUTLS"
		else
			crypto="OPENSSL"
		fi
	fi
	#fix multilib-script support. Bug #327449
	sed -i "/^libdir/s:lib$:$(get_libdir):" librtmp/Makefile || die
	if ! multilib_is_native_abi; then
		cd librtmp || die
	fi
	emake CC="$(tc-getCC)" LD="$(tc-getLD)" \
		OPT="${CFLAGS}" XLDFLAGS="${LDFLAGS}" CRYPTO="${crypto}" SYS=posix
}

multilib_src_install() {
	mkdir -p "${ED}"/usr/$(get_libdir) || die
	if multilib_is_native_abi; then
		dodoc README ChangeLog rtmpdump.1.html rtmpgw.8.html
	else
		cd librtmp || die
	fi
	emake DESTDIR="${ED}" prefix="/usr" mandir="/usr/share/man" \
	CRYPTO="${crypto}" install
}

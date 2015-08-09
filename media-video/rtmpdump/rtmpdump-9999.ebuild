# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit git-2 multilib toolchain-funcs multilib-minimal

DESCRIPTION="Open source command-line RTMP client intended to stream audio or video flash content"
HOMEPAGE="http://rtmpdump.mplayerhq.hu/"
EGIT_REPO_URI="git://git.ffmpeg.org/rtmpdump"

# the library is LGPL-2.1, the command is GPL-2
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="gnutls polarssl ssl"

DEPEND="ssl? (
		gnutls? ( >=net-libs/gnutls-2.12.23-r6[${MULTILIB_USEDEP}] )
		polarssl? ( !gnutls? ( >=net-libs/polarssl-1.3.4[${MULTILIB_USEDEP}] ) )
		!gnutls? ( !polarssl? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] ) )
		>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	)"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! use ssl && { use gnutls || use polarssl; }; then
		ewarn "USE='gnutls polarssl' are ignored without USE='ssl'."
		ewarn "Please review the local USE flags for this package."
	fi
}

src_prepare() {
	# fix Makefile ( bug #298535 , bug #318353 and bug #324513 )
	sed -i 's/\$(MAKEFLAGS)//g' Makefile \
		|| die "failed to fix Makefile"
	sed -i -e 's:OPT=:&-fPIC :' \
		-e 's:OPT:OPTS:' \
		-e 's:CFLAGS=.*:& $(OPT):' librtmp/Makefile \
		|| die "failed to fix Makefile"
	multilib_copy_sources
}

multilib_src_compile() {
	if use ssl ; then
		if use gnutls ; then
			crypto="GNUTLS"
		elif use polarssl ; then
			crypto="POLARSSL"
		else
			crypto="OPENSSL"
		fi
	fi
	#fix multilib-script support. Bug #327449
	sed -i "/^libdir/s:lib$:$(get_libdir)$:" librtmp/Makefile || die
	if ! multilib_is_native_abi; then
		cd librtmp || die
	fi
	emake CC="$(tc-getCC)" LD="$(tc-getLD)" \
		OPT="${CFLAGS}" XLDFLAGS="${LDFLAGS}" CRYPTO="${crypto}" SYS=posix
}

multilib_src_install() {
	mkdir -p "${ED}"/${DESTTREE}/$(get_libdir) || die
	if multilib_is_native_abi; then
		dodoc README ChangeLog rtmpdump.1.html rtmpgw.8.html
	else
		cd librtmp || die
	fi
	emake DESTDIR="${ED}" prefix="${DESTTREE}" mandir="${DESTTREE}/share/man" \
		CRYPTO="${crypto}" install
}

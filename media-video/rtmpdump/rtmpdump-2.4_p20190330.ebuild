# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit multilib toolchain-funcs multilib-minimal flag-o-matic

DESCRIPTION="RTMP client, librtmp library intended to stream audio or video flash content"
HOMEPAGE="https://rtmpdump.mplayerhq.hu/"

# the library is LGPL-2.1, the command is GPL-2
LICENSE="LGPL-2.1 tools? ( GPL-2 )"
SLOT="0"
IUSE="gnutls ssl static-libs +tools"

DEPEND="ssl? (
		gnutls? (
			>=net-libs/gnutls-2.12.23-r6[${MULTILIB_USEDEP},nettle(+)]
			dev-libs/nettle:0=[${MULTILIB_USEDEP}]
		)
		!gnutls? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
		>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	)"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-swf_vertification_type_2.patch"
	"${FILESDIR}/${PN}-swf_vertification_type_2_part_2.patch"
)

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	EGIT_REPO_URI="https://git.ffmpeg.org/rtmpdump.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
	SRC_URI="http://git.ffmpeg.org/gitweb/rtmpdump.git/snapshot/c5f04a58fc2aeea6296ca7c44ee4734c18401aa3.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-c5f04a5"
fi

pkg_setup() {
	if ! use ssl; then
		if use gnutls; then
			ewarn "USE='gnutls' is ignored without USE='ssl'."
			ewarn "Please review the local USE flags for this package."
		fi
	fi
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
	use ssl && use !gnutls && eapply "${FILESDIR}/${PN}-openssl-1.1-v2.patch"
	default
	multilib_copy_sources
}

multilib_src_compile() {
	if use ssl ; then
		if use gnutls ; then
			crypto="GNUTLS"
		else
			crypto="OPENSSL"
		fi
	fi
	if ! multilib_is_native_abi || ! use tools ; then
		cd librtmp || die
	fi
	emake CC="$(tc-getCC)" LD="$(tc-getLD)" AR="$(tc-getAR)" \
		OPT="${CFLAGS}" XLDFLAGS="${LDFLAGS}" CRYPTO="${crypto}" SYS=posix
}

multilib_src_install() {
	mkdir -p "${ED}"/usr/$(get_libdir) || die
	if multilib_is_native_abi && use tools ; then
		dodoc README ChangeLog rtmpdump.1.html rtmpgw.8.html
	else
		cd librtmp || die
	fi
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" mandir='$(prefix)/share/man' \
		CRYPTO="${crypto}" libdir="${EPREFIX}/usr/$(get_libdir)" install
	find "${D}" -name '*.la' -delete || die
	use static-libs || find "${D}" -name '*.a' -delete || die
}

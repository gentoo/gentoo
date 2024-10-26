# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fcaps

DESCRIPTION="A routing daemon implementing OSPF, RIPv2 & BGP for IPv4 & IPv6"
HOMEPAGE="https://bird.network.cz"
SRC_URI="ftp://bird.network.cz/pub/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~x86 ~x64-macos"
IUSE="+client custom-cflags debug libssh"

RDEPEND="
	client? (
		sys-libs/ncurses:=
		sys-libs/readline:=
	)
	filecaps? (
		acct-group/bird
		acct-user/bird
	)
	libssh? ( net-libs/libssh:= )"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	sys-devel/m4
"

FILECAPS=(
	CAP_NET_ADMIN			usr/sbin/bird
	CAP_NET_BIND_SERVICE	usr/sbin/bird
	CAP_NET_RAW				usr/sbin/bird
)

PATCHES=(
	"${FILESDIR}/${P}-musl-tests.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# This export makes compilation and test phases verbose
	export VERBOSE=1

	local myargs=(
		--localstatedir="${EPREFIX}/var"
		$(use_enable client)
		$(use_enable debug)
		$(use_enable libssh)
	)

	# lto must be enabled by default as bird is mono-threaded and use several
	# optimisations to be fast, as it may very likely be exposed to several
	# thounsand BGP updates per seconds
	# Although, we make it possible to deactivate it if wanted
	use custom-cflags && myargs+=( bird_cv_c_lto=no )

	econf "${myargs[@]}"
}

src_install() {
	if use client; then
		dobin birdc
	fi

	dobin birdcl
	dosbin bird

	newinitd "${FILESDIR}/initd-${PN}-2" ${PN}
	newconfd "${FILESDIR}/confd-${PN}-2" ${PN}

	dodoc doc/bird.conf.example
}

pkg_postinst() {
	use filecaps && \
		einfo "If you want to run bird as non-root, edit"
		einfo "'${EROOT}/etc/conf.d/bird' and set BIRD_GROUP and BIRD_USER with"
		einfo "the wanted username."
}

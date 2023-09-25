# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fcaps

DESCRIPTION="A routing daemon implementing OSPF, RIPv2 & BGP for IPv4 & IPv6"
HOMEPAGE="https://bird.network.cz"
SRC_URI="ftp://bird.network.cz/pub/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86 ~x64-macos"
IUSE="+client debug libssh"

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
	sys-devel/bison
	sys-devel/flex
	sys-devel/m4
"

FILECAPS=(
	CAP_NET_ADMIN			usr/sbin/bird
	CAP_NET_BIND_SERVICE	usr/sbin/bird
	CAP_NET_RAW				usr/sbin/bird
)

PATCHES=(
	"${FILESDIR}/${PN}-2.0.9-musl-tests.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}/var" \
		$(use_enable client) \
		$(use_enable debug) \
		$(use_enable libssh)
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

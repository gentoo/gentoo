# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="Another (RFC1413 compliant) ident daemon"
HOMEPAGE="https://oidentd.janikrabe.com/"
SRC_URI="https://files.janikrabe.com/pub/${PN}/releases/${PV}/${P}.tar.xz"

LICENSE="BSD-2 GPL-2 LGPL-2+ MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="debug ipv6 masquerade selinux"

DEPEND="masquerade? ( net-libs/libnetfilter_conntrack )"

RDEPEND="
	acct-user/oidentd
	acct-group/oidentd
	selinux? ( sec-policy/selinux-oident )
	${DEPEND}"

src_prepare() {
	sed -i '/ExecStart/ s|$| -u oidentd -g oidentd|' contrib/systemd/*.service || die

	default
}

src_configure() {
	local myconf=(
		$(use_enable debug)
		$(use_enable ipv6)
		$(use_enable masquerade libnfct)
		$(use_enable masquerade nat)
		--enable-xdgbdir
	)
	econf "${myconf[@]}"
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}-2.0.7-init ${PN}
	newconfd "${FILESDIR}"/${PN}-2.2.2-confd ${PN}

	systemd_dounit contrib/systemd/${PN}@.service
	systemd_dounit contrib/systemd/${PN}.socket
	systemd_dounit contrib/systemd/${PN}.service
}

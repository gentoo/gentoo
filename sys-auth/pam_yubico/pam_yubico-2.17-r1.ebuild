# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_yubico/pam_yubico-2.17-r1.ebuild,v 1.1 2015/05/04 03:15:16 zerochaos Exp $

EAPI=5

inherit multilib

DESCRIPTION="Library for authenticating against PAM with a Yubikey"
HOMEPAGE="https://github.com/Yubico/yubico-pam"
SRC_URI="http://opensource.yubico.com/yubico-pam/releases/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap"

RDEPEND="
	virtual/pam
	sys-auth/libyubikey
	>=sys-auth/ykclient-2.12
	>=sys-auth/ykpers-1.6
	ldap? ( net-nds/openldap )"
DEPEND="${RDEPEND}
	app-text/asciidoc"

#src_prepare() {
#	epatch "${FILESDIR}/2.11-drop_privs.patch"
#	eautoreconf
#}

src_configure() {
	#challenge response could be optional but that seems horribly dangerous to me
	econf \
		--with-cr \
		$(use_with ldap) \
		--with-pam-dir=/$(get_libdir)/security
}

src_install() {
	default
	dodoc doc/*
	#prune_libtool_files #why doesn't this work?
	find "${D}" -name '*.la' -delete || die
}

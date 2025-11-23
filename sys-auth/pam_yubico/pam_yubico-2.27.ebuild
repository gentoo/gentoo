# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools pam

DESCRIPTION="Library for authenticating against PAM with a Yubikey"
HOMEPAGE="https://github.com/Yubico/yubico-pam"
SRC_URI="https://github.com/Yubico/yubico-pam/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap test"
RESTRICT="!test? ( test )"
S="${WORKDIR}/yubico-pam-${PV}"

RDEPEND="
	sys-libs/pam
	sys-auth/libyubikey
	>=sys-auth/ykclient-2.15
	>=sys-auth/ykpers-1.6
	ldap? ( net-nds/openldap:= )"
DEPEND="${RDEPEND}
	app-text/asciidoc
	test? ( dev-perl/Net-LDAP-Server )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	#challenge response could be optional but that seems horribly dangerous to me
	local myeconfargs=(
		--with-cr
		--with-pam-dir="$(getpam_mod_dir)"
		$(use_with ldap)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dodoc doc/*
	find "${D}" -name '*.la' -delete || die
}

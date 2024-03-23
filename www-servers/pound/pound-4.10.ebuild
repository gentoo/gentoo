# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A http/https reverse-proxy and load-balancer"
HOMEPAGE="https://github.com/graygnuorg/pound"
SRC_URI="https://github.com/graygnuorg/pound/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"

DEPEND="
	dev-libs/openssl:=
	dev-libs/libpcre2:=
"
RDEPEND="
	${DEPEND}
	virtual/libcrypt:=
"

QA_CONFIG_IMPL_DECL_SKIP=(
	PCRE2regcomp	# Detecting broken Debian patched PCRE2
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--with-owner=root
		--with-group=root
	)
	econf ${myconf[@]}
}

src_install() {
	default
	newinitd "${FILESDIR}/pound.init" pound
	insinto /etc
	newins "${FILESDIR}/pound-2.2.cfg" pound.cfg
}

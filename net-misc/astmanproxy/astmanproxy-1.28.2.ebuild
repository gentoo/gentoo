# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit base flag-o-matic multilib toolchain-funcs

DESCRIPTION="Proxy for the Asterisk manager interface"
HOMEPAGE="https://github.com/davies147/astmanproxy/"
SRC_URI="https://github.com/davies147/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

IUSE=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND=""
PATCHES=( "${FILESDIR}/${P}-gentoo.diff" )

src_prepare() {
	base_src_prepare

	# Fix multilib
	sed -i -e "s#/usr/lib/#/usr/$(get_libdir)/#" "${S}/Makefile" \
		|| die "multilib sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" \
		LDFLAGS="${LDFLAGS}" \
		LD="$(tc-getLD)" \
		RAWLDFLAGS="$(raw-ldflags)"
}

src_install() {
	dosbin astmanproxy

	dodoc README VERSIONS

	docinto samples
	dodoc samples/*

	insinto /etc/asterisk
	doins configs/astmanproxy.conf
	doins configs/astmanproxy.users

	newinitd "${FILESDIR}"/astmanproxy.rc6 astmanproxy
}

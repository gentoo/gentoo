# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Proxy for the Asterisk manager interface"
HOMEPAGE="https://github.com/davies147/astmanproxy/"
SRC_URI="https://github.com/davies147/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.diff
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default

	# Fix multilib
	sed -i -e "s#/usr/lib/#/usr/$(get_libdir)/#" Makefile \
		|| die "multilib sed failed"
}

src_configure() {
	tc-export CC
}

src_install() {
	dosbin astmanproxy

	dodoc -r samples
	dodoc README VERSIONS

	insinto /etc/asterisk
	doins configs/astmanproxy.{conf,users}

	newinitd "${FILESDIR}"/astmanproxy.rc6 astmanproxy
}

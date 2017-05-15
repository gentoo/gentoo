# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit flag-o-matic systemd

DESCRIPTION="A smart ethernet switch for planet Earth"
HOMEPAGE="https://www.zerotier.com"
SRC_URI="https://github.com/${PN}/ZeroTierOne/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux ~amd64-linux ~arm ~mips"
PATCHES=( "${FILESDIR}/${P}-ZT_DEFAULT_HOME_PATH.patch" )

S="${WORKDIR}/ZeroTierOne-${PV}"

src_prepare() {
	# https://bugs.gentoo.org/show_bug.cgi?id=618396
	sed -i 's/-flto//' make-mac.mk
	default
}

src_configure() {
	append-cppflags -DZT_DEFAULT_HOME_PATH=\\\"${EPREFIX}/var/lib/${PN}-one\\\"
	append-ldflags -Wl,-z,noexecstack
}

src_compile() {
	emake STRIP=true one
}

src_install() {
	dosbin "${PN}-one"
	dosym "/usr/sbin/${PN}-one" "/usr/bin/${PN}-cli"
	dosym "/usr/sbin/${PN}-one" "/usr/bin/${PN}-idtool"
	dodoc README.md AUTHORS.md
	doman "doc/${PN}-cli.1"
	doman "doc/${PN}-idtool.1"
	doman "doc/${PN}-one.8"
	doinitd "${FILESDIR}/${PN}-one"
	systemd_dounit "${S}/debian/${PN}-one.service"
}

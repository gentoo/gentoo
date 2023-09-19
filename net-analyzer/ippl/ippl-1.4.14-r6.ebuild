# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A daemon which logs TCP/UDP/ICMP packets"
HOMEPAGE="http://pltplp.net/ippl/"
SRC_URI="http://pltplp.net/ippl/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

BDEPEND="
	app-alternatives/yacc
	sys-devel/flex"
RDEPEND="acct-user/ippl"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.14-noportresolve.patch
	"${FILESDIR}"/${PN}-1.4.14-manpage.patch
	"${FILESDIR}"/${PN}-1.4.14-privilege-drop.patch
	"${FILESDIR}"/${PN}-1.4.14-includes.patch
	"${FILESDIR}"/${PN}-1.4.14-format-warnings.patch
	# bug #351287
	"${FILESDIR}"/${PN}-1.4.14-fix-build-system.patch
)

src_configure() {
	tc-export CC
	default
}

src_install() {
	dosbin Source/ippl

	insinto /etc
	doins ippl.conf

	doman Docs/{ippl.8,ippl.conf.5}
	dodoc BUGS CREDITS HISTORY README TODO

	newinitd "${FILESDIR}"/ippl.rc ippl
}

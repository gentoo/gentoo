# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Small telnet daemon derived from the Axis tools"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~s390 ~sparc ~x86"

RDEPEND="sys-apps/shadow"

src_prepare() {
	default

	sed -e "/(STRIP)/d" \
		-e "/^CC/s|=.*|= $(tc-getCC)|" \
		-e "/fomit-frame-pointer/d" \
		-i Makefile || die
}

src_install() {
	dosbin utelnetd
	einstalldocs

	newinitd "${FILESDIR}"/utelnetd.initd utelnetd
}

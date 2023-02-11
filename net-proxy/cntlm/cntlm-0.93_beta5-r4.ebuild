# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

DESCRIPTION="Cntlm is an NTLM/NTLMv2 authenticating HTTP proxy"
HOMEPAGE="http://cntlm.sourceforge.net/"
SRC_URI="http://ftp.awk.cz/pub/${P//_}.tar.gz"
S="${WORKDIR}/${P//_}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/cntlm
	acct-user/cntlm
"

PATCHES=(
	"${FILESDIR}"/${P}-buildsystem.patch # bug #334647
	"${FILESDIR}"/${P}-configure-clang16.patch
)

src_configure() {
	tc-export CC

	econf

	# Replace default config file path in Makefile
	sed -e 's~SYSCONFDIR=/usr/local/etc~SYSCONFDIR=/etc~' -i "${S}"/Makefile || die
}

src_compile() {
	emake V=1
}

src_install() {
	dobin cntlm
	dodoc COPYRIGHT README VERSION doc/cntlm.conf
	doman doc/cntlm.1
	newinitd "${FILESDIR}"/cntlm.initd cntlm
	newconfd "${FILESDIR}"/cntlm.confd cntlm
	systemd_dounit "${FILESDIR}"/cntlm.service
	insinto /etc
	insopts -m0600
	doins doc/cntlm.conf
}

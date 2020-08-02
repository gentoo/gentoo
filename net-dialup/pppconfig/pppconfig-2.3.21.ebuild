# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="A text menu based utility for configuring ppp"
HOMEPAGE="https://packages.qa.debian.org/p/pppconfig.html"
SRC_URI="mirror://debian/pool/main/p/${PN}/${P/-/_}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND="net-dialup/ppp
	dev-util/dialog
	dev-lang/perl"
DEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
	if use nls; then
		strip-linguas -i po/
	fi
}

src_compile() {
	default

	if use nls; then
		local lang
		for lang in ${LINGUAS}; do
			msgfmt -o po/${lang}.{m,p}o || die
		done
	fi
}

src_install() {
	dodir /etc/chatscripts /etc/ppp/resolv
	dosbin 0dns-down 0dns-up dns-clean
	newsbin pppconfig pppconfig.real
	dosbin "${FILESDIR}/pppconfig"
	doman man/pppconfig.8
	dodoc debian/{copyright,changelog}

	if use nls; then
		local lang
		for lang in ${LINGUAS}; do
			insinto /usr/share/locale/${lang}/LC_MESSAGES
			newins po/${lang}.mo pppconfig.mo
		done
	fi
}

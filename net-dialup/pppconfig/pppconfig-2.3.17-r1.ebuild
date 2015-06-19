# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/pppconfig/pppconfig-2.3.17-r1.ebuild,v 1.5 2014/08/10 20:56:07 slyfox Exp $

DESCRIPTION="A text menu based utility for configuring ppp"
HOMEPAGE="http://packages.qa.debian.org/p/pppconfig.html"
SRC_URI="mirror://debian/pool/main/p/${PN}/${P/-/_}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND="net-dialup/ppp
	dev-util/dialog
	dev-lang/perl"
DEPEND="nls? ( sys-devel/gettext )"

# Supported languages and translated documentation
# Be sure all languages are prefixed with a single space!
MY_AVAILABLE_LINGUAS=" ca cs da de el es eu fi fr gl he id it ja ko lt nb nl nn pt_BR pt ro ru sk sv tl tr vi zh_CN zh_TW"
IUSE="${IUSE} ${MY_AVAILABLE_LINGUAS// / linguas_}"

src_install () {
	dodir /etc/chatscripts /etc/ppp/resolv
	dosbin 0dns-down 0dns-up dns-clean
	newsbin pppconfig pppconfig.real
	dosbin "${FILESDIR}/pppconfig"
	doman man/pppconfig.8
	dodoc debian/{copyright,changelog}

	if use nls; then
		cd "${S}/po"
		local MY_LINGUAS="" lang

		for lang in ${MY_AVAILABLE_LINGUAS} ; do
			if use linguas_${lang} ; then
				MY_LINGUAS="${MY_LINGUAS} ${lang}"
			fi
		done
		if [[ -z "${MY_LINGUAS}" ]] ; then
			#If no language is selected, install 'em all
			MY_LINGUAS="${MY_AVAILABLE_LINGUAS}"
		fi

		einfo "Locale messages will be installed for following languages:"
		einfo "   ${MY_LINGUAS}"

		for lang in ${MY_LINGUAS}; do
			msgfmt -o ${lang}.mo ${lang}.po && \
				insinto /usr/share/locale/${lang}/LC_MESSAGES && \
				newins ${lang}.mo pppconfig.mo || \
					die "failed to install locale messages for ${lang} language"
		done
	fi
}

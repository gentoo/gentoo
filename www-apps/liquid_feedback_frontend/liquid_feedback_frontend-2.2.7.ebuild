# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

PN_F=${PN}
PV_F=v${PV}
MY_P=${PN}-v${PV}

DESCRIPTION="Internet platforms for proposition development and decision making"
HOMEPAGE="http://www.public-software-group.org/liquid_feedback"
SRC_URI="http://www.public-software-group.org/pub/projects/liquid_feedback/frontend/v${PV}/${MY_P}.tar.gz
l10n_it? ( mirror://gentoo/${PN}-italian-${PV}.tar.gz )"

LICENSE="HPND CC-BY-2.5"
SLOT="0"
KEYWORDS="~amd64"
IUSE="l10n_de l10n_el l10n_en l10n_eo l10n_it"

RDEPEND=">=www-apps/liquid_feedback_core-2.2.6"
DEPEND="www-apps/rocketwiki-lqfb
	www-servers/apache
	${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare () {
	for lang in zh-Hans zh-TW ; do
		rm -f locale/help/*.${lang}.txt
	done
	for lang in de el en eo it ; do
		if ! use l10n_${lang}; then
			rm -f locale/help/*.${lang}.txt
		fi
	done
}

src_compile() {
	emake -C locale
}

src_install() {
	dodoc README
	dodoc "${FILESDIR}"/lqfb.example.com.conf
	dodoc "${FILESDIR}"/postinstall-en.txt

	insinto /var/lib/${PN}
	doins -r app db env model static tmp utils
	insinto /var/lib/${PN}/locale
	doins locale/*.lua
	insinto /var/lib/${PN}/locale/help
	eshopts_push -s nullglob
	for helpFile in locale/help/*.html ; do
		doins $helpFile
	done
	eshopts_pop

	insinto /etc/${PN}
	doins "${FILESDIR}"/myconfig.lua config/*
	dosym /etc/${PN} /var/lib/${PN}/config

	insinto /usr/share/${PN}
	doins "${FILESDIR}"/lqfb-apache.conf

	fowners apache:apache /var/lib/${PN}/tmp
}

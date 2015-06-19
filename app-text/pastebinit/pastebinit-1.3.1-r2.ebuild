# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pastebinit/pastebinit-1.3.1-r2.ebuild,v 1.4 2015/04/08 07:30:32 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit python-r1

DESCRIPTION="A software that lets you send anything you want directly to a
pastebin from the command line."
HOMEPAGE="https://launchpad.net/pastebinit"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="crypt"

RDEPEND="${PYTHON_DEPS}
	dev-python/configobj[${PYTHON_USEDEP}]
	crypt? ( app-crypt/gnupg )"
DEPEND="app-text/docbook-xsl-stylesheets"

src_prepare() {
	local mo=""

	for lang in ${LINGUAS}; do
		if [ -f po/${lang}.po ]; then
			mo="${mo} ${lang}.mo"
		fi
	done

	sed -i -e "/^build-mo/s/:.*/:${mo}/" po/Makefile
}

src_compile() {
	emake -C po
	xsltproc --nonet \
		"${EROOT}"usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl \
		pastebinit.xml || die
}

src_install() {
	dobin pastebinit utils/pbput
	python_replicate_script "${ED}usr/bin/${PN}"
	dosym pbput /usr/bin/pbget
	use crypt && dosym pbput /usr/bin/pbputs
	dodoc README
	doman pastebinit.1 utils/*.1
	insinto /usr/share/locale
	[[ -d po/mo ]] && doins -r po/mo/*
	insinto /usr/share
	doins -r pastebin.d
}

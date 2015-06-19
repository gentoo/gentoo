# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/rsstool/rsstool-1.0.1_rc2.ebuild,v 1.8 2013/03/13 11:29:18 ago Exp $

EAPI=5

inherit toolchain-funcs

MY_P=${PN}-${PV/_}

DESCRIPTION="cmdline tool to read, parse, merge, and write RSS (and Atom) feeds"
HOMEPAGE="http://rsstool.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-libs/libxml2
	net-misc/curl"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}-src/src

src_prepare() {
	sed -e '1i#!/bin/bash' -i configure || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" BINDIR="/usr/bin" install

	dohtml ../{changes,faq,readme}.html
}

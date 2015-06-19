# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/apinger/apinger-0.4.1.ebuild,v 1.1 2015/01/19 19:26:14 jer Exp $

EAPI=5
inherit autotools

DESCRIPTION="Alarm Pinger"
HOMEPAGE="https://github.com/Jajcus/apinger/"
SRC_URI="${HOMEPAGE}archive/${PN^^}_${PV//./_}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	sys-devel/flex
	virtual/yacc
"

S=${WORKDIR}/${PN}-${PN^^}_${PV//./_}

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	sed -i -e 's|\\$||g' acinclude.m4 || die
	eautoreconf
}

src_compile() {
	emake -C src/ cfgparser1.h
	default
}

src_install() {
	default
	insinto /etc
	doins src/${PN}.conf
}

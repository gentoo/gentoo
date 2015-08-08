# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_PN=${PN/-bin}
MY_P="${MY_PN}-${PV}"
DESCRIPTION="free open source desktop alternative to Microsoft Project"
HOMEPAGE="http://openproj.org/"
SRC_URI="mirror://sourceforge/openproj/${MY_P}.tar.gz
	http://openproj.cvs.sourceforge.net/viewvc/openproj/openproj_build/resources/openproj.desktop?revision=1.2 -> ${MY_PN}-1.2.desktop
	http://openproj.cvs.sourceforge.net/viewvc/openproj/openproj_build/resources/openproj.png?revision=1.1 -> ${MY_PN}-1.1.png"

LICENSE="CPAL-1.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz
	cp "${DISTDIR}"/${MY_PN}-*.{desktop,png} ./ || die
	cd "${S}"
	rm -rf license openproj.bat readme.html
}

src_prepare() {
	sed -i \
		-e "/^OPENPROJ_HOME0=/s:=.*:=/opt/${MY_PN}:" \
		openproj.sh || die
}

src_install() {
	local d="/opt/${MY_PN}"
	insinto ${d}
	doins -r * || die
	fperms a+rx ${d}/openproj.sh

	dodir /opt/bin
	dosym ../${MY_PN}/openproj.sh /opt/bin/openproj || die

	newmenu ../${MY_PN}-*.desktop ${MY_PN}.desktop || die
	newmenu ../${MY_PN}-*.png ${MY_PN}.png || die
}

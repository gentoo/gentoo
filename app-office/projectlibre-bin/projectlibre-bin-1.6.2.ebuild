# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

MY_PN=${PN/-bin}
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An open source desktop alternative to Microsoft Project"
HOMEPAGE="http://www.projectlibre.org/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz
	mirror://gentoo/${MY_PN}.png"

LICENSE="CPAL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.8"
DEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz
	cp "${FILESDIR}"/${MY_PN}.desktop "${DISTDIR}"/${MY_PN}.png ./ || die
	cd "${S}"
	rm -rf license projectlibre.bat
}

src_prepare() {
	eapply_user
	sed -i \
		-e "/^OPENPROJ_HOME0=/s:=.*:=/opt/${MY_PN}:" \
		${MY_PN}.sh || die
}

src_install() {
	local d="/opt/${MY_PN}"
	insinto ${d}
	doins -r *
	fperms a+rx ${d}/${MY_PN}.sh

	dodir /opt/bin
	dosym ../${MY_PN}/${MY_PN}.sh /opt/bin/${MY_PN}

	newmenu ../${MY_PN}.desktop ${MY_PN}.desktop || die
	newicon ../${MY_PN}.png ${MY_PN}.png || die
}

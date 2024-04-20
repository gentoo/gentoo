# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

MY_PN=${PN/-bin}
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Open source desktop alternative to Microsoft Project"
HOMEPAGE="https://www.projectlibre.com/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz
	https://sourceforge.net/p/projectlibre/code/ci/master/tree/projectlibre_build/resources/${MY_PN}.desktop?format=raw -> ${MY_PN}.desktop
	https://sourceforge.net/p/projectlibre/code/ci/master/tree/projectlibre_build/resources/${MY_PN}.png?format=raw -> ${MY_PN}.png"
S="${WORKDIR}/${MY_P}"

LICENSE="CPAL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8"

src_unpack() {
	unpack ${MY_P}.tar.gz
	cp "${FILESDIR}"/${MY_PN}.desktop "${DISTDIR}"/${MY_PN}.png ./ || die
	cd "${S}" || die
	rm -rf license projectlibre.bat || die
}

src_prepare() {
	default
	sed -i \
		-e "/^PROJECTLIBRE_HOME0=/s|=.*|=\"/opt/${MY_PN}\"|" \
		${MY_PN}.sh || die
}

src_install() {
	local d="/opt/${MY_PN}"
	insinto ${d}
	doins -r *
	fperms a+rx ${d}/${MY_PN}.sh

	dodir /opt/bin
	dosym ../${MY_PN}/${MY_PN}.sh /opt/bin/${MY_PN}

	doicon ../${MY_PN}.png
	domenu ../${MY_PN}.desktop
}

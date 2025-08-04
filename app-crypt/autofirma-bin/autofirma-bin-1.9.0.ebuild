# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit rpm xdg

DESCRIPTION="Spanish government certificate request generator"
HOMEPAGE="https://administracionelectronica.gob.es/ctt/verPestanaGeneral.htm?idIniciativa=clienteafirma
	https://github.com/ctt-gob-es/clienteafirma"

# Upstream blocks wget, so we need a fallback option
SRC_URI="
	https://estaticos.redsara.es/comunes/autofirma/$(ver_rs 1- /)/Autofirma_Linux_Fedora.zip -> ${P}.zip
	https://dev.gentoo.org/~pacho/${PN}/${P}.zip
"
S="${WORKDIR}"

LICENSE="|| ( GPL-2 EUPL-1.1 )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/nss[utils]
	virtual/jre:17
"
BDEPEND="app-arch/unzip"

QA_PREBUILT="*"

src_unpack() {
	default
	rpm_unpack ./${PN/-bin}-$(ver_cut 1-2)-1.noarch_FEDORA.rpm
	rm -r "${S}/usr/share/licenses" || die
}

src_install() {
	dodir /
	cd "${ED}" || die
	mv "${S}"/usr . || die

	# Fix .desktop file
	sed -i -e '/Version/d' \
		"${ED}"/usr/share/applications/${PN/-bin}.desktop || die
	sed -i -e 's/Utilities/X-Utilities/g' \
		"${ED}"/usr/share/applications/${PN/-bin}.desktop || die
	sed -i -e 's/Signature/X-Signature/g' \
		"${ED}"/usr/share/applications/${PN/-bin}.desktop || die
}

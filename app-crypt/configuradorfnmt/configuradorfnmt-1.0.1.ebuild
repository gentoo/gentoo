# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-utils-2 rpm xdg

DESCRIPTION="Spanish government certificate request generator"
HOMEPAGE="https://www.cert.fnmt.es/"
SRC_URI="https://descargas.cert.fnmt.es/Linux/configuradorfnmt-1.0.1-0.x86_64.rpm"

LICENSE="FNMT-RCM"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="virtual/jre:1.8"
DEPEND="${RDEPEND}"

S=${WORKDIR}/

src_install() {
	java-pkg_dojar "usr/lib64/${PN}/${PN}.jar"
	java-pkg_dolauncher
	doicon "usr/lib64/${PN}/${PN}.png"
	make_desktop_entry "${PN} %u" "Configurador FNMT" "${PN}" "Utility" "Comment[es]=Generador de certificados de la FNMT\nMimeType=x-scheme-handler/fnmtcr"
}

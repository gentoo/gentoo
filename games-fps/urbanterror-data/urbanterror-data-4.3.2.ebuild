# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit check-reqs eutils

ENGINE_PV=${PV}

MY_PN=UrbanTerror
MY_PV=43_full

DESCRIPTION="Data files for UrbanTerror"
HOMEPAGE="http://www.urbanterror.info/home/"
SRC_URI="https://up.barbatos.fr/urt/${MY_PN}${MY_PV}.zip -> ${P}.zip
	https://upload.wikimedia.org/wikipedia/commons/5/56/Urbanterror.svg -> ${PN}.svg"

# fetch updates recursively for |4.3.x-4.3.0|
if [[ "${PV}" != "4.3.0" ]]; then
	MY_CTR=0
	while [[ "${MY_CTR}" -lt "${PV/4.3./}" ]]; do
		SRC_URI="${SRC_URI} https://up.barbatos.fr/urt/${MY_PN}-4.3.${MY_CTR}-to-4.3.$(( ${MY_CTR} + 1 )).zip -> ${PN}-4.3.${MY_CTR}-to-4.3.$(( ${MY_CTR} + 1 )).zip"
		MY_CTR=$(( ${MY_CTR} + 1 ))
	done
fi
unset MY_CTR

LICENSE="Q3AEULA-20000111 urbanterror-4.2-maps"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_PN}43"

CHECKREQS_DISK_BUILD="3300M"
CHECKREQS_DISK_USR="1400M"

src_prepare() {
	default

	# apply updates we fetched before
	# again recursively for |4.3.x - 4.3.0|
	local MY_CTR
	if [[ "${PV}" != "4.3.0" ]]; then
		MY_CTR=0
		while [[ "${MY_CTR}" -lt "${PV/4.3./}" ]]; do
			cp -dfpr \
				"${WORKDIR}"/${MY_PN}-4.3.${MY_CTR}-to-4.3.$(( ${MY_CTR} + 1 ))/* "${S}"
			MY_CTR=$(( ${MY_CTR} + 1 ))
		done
	fi
}

src_install() {
	newicon -s scalable "${DISTDIR}"/${PN}.svg urbanterror.svg
	insinto /usr/share/urbanterror/q3ut4
	doins q3ut4/*.pk3
	# These files are *essential* for startup
	newins q3ut4/server_example.cfg server.cfg
	newins q3ut4/autoexec_example.cfg autoexec.cfg

	dodoc q3ut4/readme43.txt
	docinto examples
	dodoc q3ut4/{server_example.cfg,mapcycle_example.txt}
}

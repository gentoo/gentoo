# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

# Upstream is still using strange version numbers
MY_PV="00${PV}.0000.0000"
MY_P="${PN}-${MY_PV}"
MY_PN="STORCLI_SAS3.5_P25"
DESCRIPTION="MegaRAID StorCLI (successor of the MegaCLI)"
HOMEPAGE="https://www.broadcom.com/support/download-search?dk=storcli"
SRC_URI="https://docs.broadcom.com/docs-and-downloads/host-bus-adapters/host-bus-adapters-common-files/sas_sata_nvme_12g_p25/${MY_PN}.zip -> ${P}.zip"

LICENSE="Avago LSI BSD"
SLOT="0"
KEYWORDS="-* amd64"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

QA_PREBUILT="/opt/MegaRAID/storcli/storcli64"

src_unpack() {
	default
	rpm_unpack ./${MY_PN}/univ_viva_cli_rel/Unified_storcli_all_os/Linux/${MY_P}-1.noarch.rpm
	unzip ./${MY_PN}/univ_viva_cli_rel/Unified_storcli_all_os/JSON-Schema/JSON_SCHEMA_FILES.zip
}

src_prepare() {
	default

	find JSON-Schema/ -type f -name *.json -exec sed -i -e 's|/home/|/usr/share/storcli/|g' {} \+ || die
}

src_install() {
	insinto /usr/share/storcli
	doins JSON-Schema/*.xlsx
	doins ${MY_PN}/univ_viva_cli_rel/Unified_storcli_all_os/storcliconf.ini

	insinto /usr/share/storcli/JSON-Schema/
	doins JSON-Schema/*.json

	exeinto /opt/MegaRAID/storcli
	doexe opt/MegaRAID/storcli/storcli64

	dosym ../../opt/MegaRAID/storcli/storcli64 /usr/sbin/storcli
	dosym ../../opt/MegaRAID/storcli/storcli64 /usr/sbin/storcli64
}

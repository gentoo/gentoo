# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

# Upstream is still using strange version numbers
MY_PV="00${PV}.0000.0000"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="MegaRAID StorCLI (successor of the MegaCLI)"
HOMEPAGE="https://www.broadcom.com/support/download-search?dk=storcli"
SRC_URI="https://docs.broadcom.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/${MY_PV}_Unified_StorCLI.zip -> ${P}.zip"

LICENSE="Avago LSI BSD"
SLOT="0"
KEYWORDS="-* amd64 x86"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

QA_PREBUILT="/opt/MegaRAID/storcli/storcli /opt/MegaRAID/storcli/storcli64"

src_unpack() {
	default
	rpm_unpack ./Unified_storcli_all_os/Linux/${MY_P}-1.noarch.rpm
	unzip ./Unified_storcli_all_os/JSON-Schema/JSON_SCHEMA_FILES.zip
}

src_prepare() {
	default

	sed -i -e 's|/home/|/usr/share/storcli/|g' JSON-Schema/*.json
}

src_install() {
	insinto /usr/share/storcli
	doins JSON-Schema/*.xlsx
	doins ./Unified_storcli_all_os/storcliconf.ini

	insinto /usr/share/storcli/JSON-Schema/
	doins JSON-Schema/*.json

	exeinto /opt/MegaRAID/storcli
	if use x86; then
		doexe opt/MegaRAID/storcli/storcli
		dosym ../../opt/MegaRAID/storcli/storcli /usr/sbin/storcli
	else
		doexe opt/MegaRAID/storcli/storcli64
		dosym ../../opt/MegaRAID/storcli/storcli64 /usr/sbin/storcli
		dosym ../../opt/MegaRAID/storcli/storcli64 /usr/sbin/storcli64
	fi
}

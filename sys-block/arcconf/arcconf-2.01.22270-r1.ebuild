# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="v${PV//./_}"

inherit linux-info

DESCRIPTION="Microsemi Adaptec RAID Controller Command Line Utility"
HOMEPAGE="https://www.microsemi.com/"
SRC_URI="http://download.adaptec.com/raid/storage_manager/${PN}_${MY_PV}.zip"

LICENSE="Microsemi"
SLOT="0"
KEYWORDS="-* amd64 x86"

DEPEND="app-arch/unzip"

RESTRICT="fetch mirror bindist"

S="${WORKDIR}"

QA_PREBUILT="usr/bin/arcconf"

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "https://storage.microsemi.com/en-us/speed/raid/storage_manager/${PN}_${MY_PV}_zip.php"
	elog "and place it in your DISTDIR directory."
}

pkg_setup() {
	# CONFIG_HARDENED_USERCOPY_PAGESPAN makes ARCCONF segault
	if linux-info_get_any_version && linux_config_src_exists ; then
		CONFIG_CHECK="!HARDENED_USERCOPY_PAGESPAN"
		check_extra_config
	fi
}

src_install() {
	dobin linux$(usex amd64 '_x64' '')/cmdline/arcconf
}

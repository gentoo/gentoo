# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="Crypto-provider browser plugin for russian e-gov site https://gosuslugi.ru/"

SRC_URI="
	amd64? ( https://ds-plugin.gosuslugi.ru/plugin/upload/assets/distrib/IFCPlugin-x86_64.deb -> ${P}_amd64.deb )
	x86? ( https://ds-plugin.gosuslugi.ru/plugin/upload/assets/distrib/IFCPlugin-i386.deb -> ${P}_x86.deb )
	x64-macos? ( https://ds-plugin.gosuslugi.ru/plugin/upload/assets/distrib/IFCPlugin.pkg -> ${P}_mac.pkg )
"
#	x86-macos? ( https://ds-plugin.gosuslugi.ru/plugin/upload/assets/distrib/IFCPlugin.pkg -> ${P}_mac.pkg )
#	x86-winnt? ( https://ds-plugin.gosuslugi.ru/plugin/htdocs/plugin/IFCPlugin.msi )
#	x64-winnt? ( https://ds-plugin.gosuslugi.ru/plugin/htdocs/plugin/IFCPlugin-x64.msi )

HOMEPAGE="http://gosuslugi.ru/"
LICENSE="all-rights-reserved"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="multilib"

REQUIRED_USE="amd64? ( multilib )"

# TODO: minimal useflag (I can't do it now, since
# it seems like I brake my token and it is uninitialized now)
RDEPEND="
	dev-libs/libxml2:2
	sys-apps/pcsc-lite:0
	virtual/libusb:0
"
DEPEND="${RDEPEND}"

QA_PREBUILT="*"
QA_SONAME_NO_SYMLINK="usr/lib32/.* usr/lib64/.*"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
	rm usr/lib/mozilla/plugins/lib/libcapi_engine_linux.so
}

src_install() {
	insinto /
	doins -r usr etc opt
	dobin usr/bin/ifc_chrome_host
	keepdir /var/log/ifc
	fperms 777 /var/log/ifc
}

pkg_postinst() {
	cd /etc/update_ccid_boundle
	sh ./update_ccid_boundle.sh
}

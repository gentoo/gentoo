# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV^^}"
MY_PN="Oracle_VirtualBox_Extension_Pack"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="PUEL extensions for VirtualBox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}.vbox-extpack -> ${MY_P}.tar.gz"
S="${WORKDIR}"

LICENSE="PUEL-12"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
RESTRICT="bindist mirror strip"

RDEPEND="
	|| (
		=app-emulation/virtualbox-${PV}*
		=app-emulation/virtualbox-kvm-${PV}*
	)
"

QA_PREBUILT="usr/lib*/virtualbox/ExtensionPacks/${MY_PN}/*"

src_install() {
	insinto /usr/$(get_libdir)/virtualbox/ExtensionPacks/${MY_PN}
	doins -r linux.${ARCH}
	doins ExtPack* PXE-Intel.rom
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

MAIN_PV="$(ver_cut 1-3)"
if [[ ${PV} = *_beta* ]] || [[ ${PV} = *_rc* ]] ; then
	MY_PV="${MAIN_PV}_$(ver_cut 5-6)"
	DEP_PV="${MY_PV}"
	MY_PV="${MY_PV/beta/BETA}"
	MY_PV="${MY_PV/rc/RC}"
else
	MY_PV="${MAIN_PV}"
	DEP_PV="${MAIN_PV}"
fi
VBOX_BUILD_ID="$(ver_cut 4)"
MY_PN="Oracle_VM_VirtualBox_Extension_Pack"
MY_P="${MY_PN}-${MY_PV}-${VBOX_BUILD_ID}"

DESCRIPTION="PUEL extensions for VirtualBox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}.vbox-extpack -> ${MY_P}.tar.gz"

LICENSE="PUEL"
SLOT="0"
[[ "${PV}" == *_beta* ]] || [[ "${PV}" == *_rc* ]] || \
KEYWORDS="~amd64"
IUSE=""
RESTRICT="bindist mirror strip"

RDEPEND="~app-emulation/virtualbox-${DEP_PV}"

S="${WORKDIR}"

QA_PREBUILT="/usr/lib*/virtualbox/ExtensionPacks/${MY_PN}/.*"

src_install() {
	insinto /usr/$(get_libdir)/virtualbox/ExtensionPacks/${MY_PN}
	doins -r linux.${ARCH}
	doins ExtPack* PXE-Intel.rom
}

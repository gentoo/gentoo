# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils multilib versionator

MAIN_PV="$(get_version_component_range 1-3)"
if [[ ${PV} = *_beta* ]] || [[ ${PV} = *_rc* ]] ; then
	MY_PV="${MAIN_PV}_$(get_version_component_range 5)"
	DEP_PV="${MY_PV}"
	MY_PV="${MY_PV/beta/BETA}"
	MY_PV="${MY_PV/rc/RC}"
else
	MY_PV="${MAIN_PV}"
	DEP_PV="${MAIN_PV}"
fi
VBOX_BUILD_ID="$(get_version_component_range 4)"
MY_PN="Oracle_VM_VirtualBox_Extension_Pack"
MY_P="${MY_PN}-${MY_PV}-${VBOX_BUILD_ID}"

DESCRIPTION="PUEL extensions for VirtualBox"
HOMEPAGE="http://www.virtualbox.org/"
SRC_URI="http://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}.vbox-extpack -> ${MY_P}.tar.gz"

LICENSE="PUEL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="~app-emulation/virtualbox-${DEP_PV}"

S="${WORKDIR}"

QA_PREBUILT="/usr/$(get_libdir)/virtualbox/ExtensionPacks/${MY_PN}/.*"

src_install() {
	insinto /usr/$(get_libdir)/virtualbox/ExtensionPacks/${MY_PN}
	doins -r linux.${ARCH}
	doins ExtPack* PXE-Intel.rom
}

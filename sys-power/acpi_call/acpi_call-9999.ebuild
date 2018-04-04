# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info linux-mod

HOMEPAGE="https://github.com/teleshoes/acpi_call"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
	KEYWORDS=""
else
	inherit vcs-snapshot
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A kernel module that enables you to call ACPI methods"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

CONFIG_CHECK="ACPI"
MODULE_NAMES="acpi_call(misc:${S})"
BUILD_TARGETS="default"

src_compile(){
	BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}"
	linux-mod_src_compile
}

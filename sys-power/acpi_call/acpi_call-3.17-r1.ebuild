# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod

HOMEPAGE="https://github.com/teleshoes/acpi_call"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
	KEYWORDS=""
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A kernel module that enables you to call ACPI methods"

LICENSE="GPL-2"
SLOT="0"

BUILD_TARGETS="default"
CONFIG_CHECK="ACPI"
MODULE_NAMES="acpi_call(misc:${S})"

PATCHES=(
	"${FILESDIR}/${P}-linux-4.12.patch"
	"${FILESDIR}/${P}-linux-4.14.patch"
)

src_compile(){
	BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}"
	linux-mod_src_compile
}

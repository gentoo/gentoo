# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod

MY_DATE="$(ver_cut 4)"
MY_PN="${PN/smc-/}"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="Updates the BIOS and IPMI firmware and system settings on Supermicro mainboards"
HOMEPAGE="https://www.supermicro.com"
#SRC_URI="${MY_PN}_${MY_PV}_Linux_x86_64_${MY_DATE}.tar.gz"
SRC_URI="https://www.supermicro.com/Bios/sw_download/527/${MY_PN}_${MY_PV}_Linux_x86_64_${MY_DATE}.tar.gz"
S="${WORKDIR}/${MY_PN}_${MY_PV}_Linux_x86_64"

LICENSE="supermicro"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="module"

RDEPEND="
	sys-libs/zlib
	sys-power/iasl
	module? ( !sys-apps/smc-sum-driver )
"

RESTRICT="bindist mirror"

DOCS=(
	"PlatformFeatureSupportMatrix.pdf"
	"ReleaseNote.txt"
	"SUM_UserGuide.pdf"
	"sumrc.sample"
	"ExternalData/SMCIPID.txt"
	"ExternalData/VENID.txt"
)

PATCHES=( "${FILESDIR}/${PN}-2.7.0.20210903-missing-include.patch" )

BUILD_TARGETS="default"
MODULE_NAMES="sum_bios(misc:${S}/driver/Source/Linux)"

QA_PREBUILT="usr/bin/smc-sum"

src_prepare() {
	default

	# Install new Makefile to respect users CFLAGS and LDFLAGS
	cp "${FILESDIR}"/makefile driver/Source/Linux/Makefile || die
}

src_compile() {
	if use module; then
		BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}/driver/Source/Linux"
		linux-mod_src_compile
	else
		:;
	fi
}

src_install() {
	newbin sum smc-sum
	einstalldocs

	use module && linux-mod_src_install
}

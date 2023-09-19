# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODULES_OPTIONAL_IUSE="+module"

inherit linux-mod-r1

MY_DATE="$(ver_cut 4)"
MY_PN="${PN/smc-/}"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="Updates the BIOS and IPMI firmware and system settings on Supermicro mainboards"
HOMEPAGE="https://www.supermicro.com"
SRC_URI="https://www.supermicro.com/Bios/sw_download/570/${MY_PN}_${MY_PV}_Linux_x86_64_${MY_DATE}.tar.gz"
S="${WORKDIR}/${MY_PN}_${MY_PV}_Linux_x86_64"

LICENSE="supermicro"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="module"

RDEPEND="
	sys-libs/zlib
	sys-power/iasl
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

QA_PREBUILT="usr/bin/smc-sum"

src_prepare() {
	default

	# Install new Makefile to respect users CFLAGS and LDFLAGS
	cp "${FILESDIR}"/makefile driver/Source/Linux/Makefile || die

	linux-mod-r1_pkg_setup
}

src_compile() {
	local modargs=( KDIR="${KV_OUT_DIR}" )
	local modlist=( sum_bios="misc:driver/Source/Linux" )

	linux-mod-r1_src_compile
}

src_install() {
	newbin sum smc-sum
	einstalldocs

	linux-mod-r1_src_install
}

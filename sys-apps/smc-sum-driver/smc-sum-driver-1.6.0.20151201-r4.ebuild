# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod

MY_DATE="$(ver_cut 4)"
MY_PN="${PN//-/_}"
MY_PV="$(ver_cut 1-3)"
MY_P="${MY_PN/smc_/}_V${MY_PV}"

DESCRIPTION="Supermicro Update Manager (SUM) kernel module"
HOMEPAGE="https://www.supermicro.com"
SRC_URI="${MY_P}_${MY_DATE}.tar.gz"
S="${WORKDIR}/${MY_P}/Linux"

KEYWORDS="-* amd64 x86"
LICENSE="supermicro"
SLOT="0"

RESTRICT="bindist fetch mirror"

BUILD_TARGETS="default"
MODULE_NAMES="sum_bios(misc:${S})"

pkg_nofetch() {
	elog "Please contact the Supermicro support at support@supermicro.com,"
	elog "in order to obtain a copy of ${A}"
	elog "and place it in your DISTDIR directory."
}

src_prepare() {
	default

	# Install new Makefile to respect users CFLAGS and LDFLAGS
	cp "${FILESDIR}"/makefile Makefile || die
}

src_compile() {
	BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}"

	linux-mod_src_compile
}

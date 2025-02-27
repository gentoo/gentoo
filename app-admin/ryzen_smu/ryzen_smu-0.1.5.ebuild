# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dkms

DESCRIPTION="Kernel driver for AMD Ryzen's System Management Unit"
HOMEPAGE="https://gitlab.com/leogx9r/ryzen_smu"
SRC_URI="https://gitlab.com/leogx9r/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	default
	sed -e "s/@VERSION@/${PV}/" -e 's/@CFLGS@/${HOSTCFLAGS}/' \
		-i dkms.conf || die
}

src_compile() {
	local modlist=( ryzen_smu )
	local modargs=( KERNEL_BUILD="${KV_OUT_DIR}" )

	dkms_src_compile
}

src_install() {
	dkms_src_install

	insinto /usr/lib/modules-load.d
	doins "${FILESDIR}"/ryzen_smu.conf
}

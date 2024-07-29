# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CONFIG_CHECK="~X86_CPUID ~X86_MSR"
inherit autotools linux-info

EGIT_COMMIT="eec71d977a83f8dc76bc3ccc6de5cbd3be378572"

DESCRIPTION="Utilities allowing the read and write of CPU model-specific registers (MSR)"
HOMEPAGE="https://github.com/intel/msr-tools"
SRC_URI="https://github.com/intel/msr-tools/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare() {
	default
	eautoreconf
}

pkg_postinst() {
	einfo "Be sure that before using msr-tools utilities Linux kernel modules"
	einfo "cpuid.ko and msr.ko are loaded."
}

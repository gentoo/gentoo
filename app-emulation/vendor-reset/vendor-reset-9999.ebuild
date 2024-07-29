# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/gnif/vendor-reset.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="4b466e92a2d9f76ce1082cde982c7be0be91e248"
	SRC_URI="https://github.com/gnif/vendor-reset/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Linux kernel vendor specific hardware reset module"
HOMEPAGE="https://github.com/gnif/vendor-reset"

LICENSE="GPL-2"
SLOT="0"

CONFIG_CHECK="FTRACE KPROBES PCI_QUIRKS KALLSYMS FUNCTION_TRACER"

src_compile() {
	local modlist=( vendor-reset )
	local modargs=( KDIR="${KV_OUT_DIR}" )
	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

	insinto /etc/modules-load.d/
	newins "${FILESDIR}"/modload.conf vendor-reset.conf
}

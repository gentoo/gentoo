# Copyright 1999-2024 Gentoo Authors
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

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

CONFIG_CHECK="FTRACE KPROBES PCI_QUIRKS KALLSYMS FUNCTION_TRACER"

PATCHES=(
	"${FILESDIR}/${PN}-0.1.1-allow-correct-compilation-with-clang.patch"
	"${FILESDIR}/${PN}-0.1.1-fix-build-on-kernel-6.8.patch"
)

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

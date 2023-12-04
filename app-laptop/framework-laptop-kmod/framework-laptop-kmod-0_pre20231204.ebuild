# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

COMMIT_HASH="d5367eb9e5b5542407494d04ac1a0e77f10cc89d"
DESCRIPTION="Kernel module to expose more Framework Laptop stuff"
HOMEPAGE="https://github.com/DHowett/framework-laptop-kmod"
SRC_URI="https://github.com/DHowett/framework-laptop-kmod/archive/${COMMIT_HASH}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

CONFIG_CHECK="
	~CROS_EC
	~CROS_EC_LPC
"

DOCS=(
	README.md
)

pkg_setup() {
	linux-mod-r1_pkg_setup

	MODULES_MAKEARGS+=(
		KDIR="${KERNEL_DIR}"
	)
}

pkg_pretend() {
	check_extra_config
}

src_compile() {
	local modlist=(
		framework_laptop
	)
	linux-mod-r1_src_compile
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst

	#if kernel_is -lt 6 7 0; then
		ewarn "For the Framework Laptop 13 AMD Ryzen 7040 series and the Framework Laptop 16a,"
		ewarn "you will need to apply the patch series from this URL:"
		ewarn "https://lore.kernel.org/chrome-platform/20231005160701.19987-1-dustin@howett.net/"
	#fi
}

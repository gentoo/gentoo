# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Bumblebee-Project/${PN}.git"
	EGIT_BRANCH="develop"
else
	PATCHES=( "${FILESDIR}/${PN}-0.8-kernel-4.12.patch" )
	SRC_URI="https://github.com/Bumblebee-Project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Toggle discrete NVIDIA Optimus graphics card"
HOMEPAGE="https://github.com/Bumblebee-Project/bbswitch"

SLOT="0"
LICENSE="GPL-3+"
IUSE=""

DEPEND="
	virtual/linux-sources
	sys-kernel/linux-headers
"
RDEPEND=""

MODULE_NAMES="bbswitch(acpi)"

pkg_setup() {
	linux-mod_pkg_setup

	BUILD_TARGETS="default"
	BUILD_PARAMS="KVERSION=${KV_FULL}"
}

src_prepare() {
	# Fix build failure, bug #513542
	sed "s%^KDIR :=.*%KDIR := ${KERNEL_DIR}%g" -i Makefile || die

	default
}

src_install() {
	einstalldocs

	insinto /etc/modprobe.d
	newins "${FILESDIR}"/bbswitch.modprobe bbswitch.conf

	linux-mod_src_install
}

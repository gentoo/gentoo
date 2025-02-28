# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dkms

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Bumblebee-Project/${PN}.git"
	EGIT_BRANCH="develop"
else
	COMMIT="23891174a80ea79c7720bcc7048a5c2bfcde5cd9"
	SRC_URI="https://github.com/Bumblebee-Project/bbswitch/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/bbswitch-${COMMIT}"
fi

DESCRIPTION="Toggle discrete NVIDIA Optimus graphics card"
HOMEPAGE="https://github.com/Bumblebee-Project/bbswitch"

LICENSE="GPL-3+"
SLOT="0"

DEPEND="
	virtual/linux-sources
	sys-kernel/linux-headers
"

PATCHES=( "${FILESDIR}/${PN}-kernel-5.18.patch" )

pkg_setup() {
	linux-mod-r1_pkg_setup
}

src_prepare() {
	# Fix build failure, bug #513542 and bug #761370
	sed "s%^KDIR :=.*%KDIR := ${KV_OUT_DIR:-$KERNEL_DIR}%g" -i Makefile || die
	sed "s/#MODULE_VERSION#/${PV}/" -i dkms/dkms.conf || die
	mv dkms/dkms.conf dkms.conf || die

	default
}

src_compile() {
	local modlist=( bbswitch=acpi )
	local modargs=(
		KVERSION=${KV_FULL}
	)
	dkms_src_compile
}

src_install() {
	insinto /etc/modprobe.d
	newins "${FILESDIR}"/bbswitch.modprobe bbswitch.conf
	dkms_src_install
}

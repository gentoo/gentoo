# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGO_PN="github.com/NVIDIA/${PN}"

inherit go-module

DESCRIPTION="NVIDIA container runtime toolkit"
HOMEPAGE="https://github.com/NVIDIA/container-toolkit"

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NVIDIA/${PN}.git"
else
	SRC_URI="
		https://github.com/NVIDIA/${PN}/archive/v${PV/_rc/-rc.}.tar.gz -> ${P}.tar.gz
	"
	S="${WORKDIR}/${PN}-${PV/_rc/-rc.}"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0/${PV}"

# Some tests may require specific environmental setups or additional hardware.
RESTRICT="test" # Bug 831702

# Bug 950233 version should not be newer than libnvidia-container
RDEPEND="
	~sys-libs/libnvidia-container-${PV}
"

src_compile() {
	emake binaries
}

src_install() {
	dobin nvidia-cdi-hook \
		nvidia-container-runtime \
		nvidia-container-runtime.cdi \
		nvidia-container-runtime.legacy \
		nvidia-container-runtime-hook \
		nvidia-ctk
	insinto "/etc/nvidia-container-runtime"
	doins "${FILESDIR}/config.toml"
}

pkg_postinst() {
	elog "Your docker or containerd (if applicable) service may need restart"
	elog "after install this package:"
	elog "OpenRC: rc-service containerd restart; rc-service docker restart"
	elog "systemd: systemctl restart containerd; systemctl restart docker"
	elog "You may need to edit your /etc/nvidia-container-runtime/config.toml"
	elog "file before running ${PN} for the first time."
	elog "For details, please see the NVIDIA docker manual page."
}

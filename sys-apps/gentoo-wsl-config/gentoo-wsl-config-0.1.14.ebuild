# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="WSL2 configuration for Gentoo Linux"

HOMEPAGE="https://wiki.gentoo.org/wiki/Project:WSL"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gentoo-wsl-config.git"
else
	SRC_URI="https://gitweb.gentoo.org/proj/gentoo-wsl-config.git/snapshot/${P}.tar.bz2"
	KEYWORDS="amd64 arm64" # Only add arches supported by WSL
fi

LICENSE="GPL-3+"
SLOT="0"

IUSE="+interop systemd"

RDEPEND="
	systemd? (
		sys-apps/systemd
	)
	app-eselect/eselect-repository
"

src_configure() {
	# Only 'enables' systemd insofar as the generated config will attempt to
	# have WSL start systemd; this does not build anything against systemd
	local emesonargs=(
		$(meson_use interop)
		$(meson_use systemd)
	)
	meson_src_configure
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Gentoo WSL configuration has been installed."
		elog "Please run 'wsl --shutdown' to apply the changes."
		elog "You may also want to run 'wsl --update' to ensure you have the latest WSL version."
		if use systemd; then
			ewarn "Systemd support is enabled, however some units are incompatible with WSL."
			ewarn "Please disable or mask the following units:"
			ewarn "	* systemd-resolved.service"
			ewarn "	* systemd-networkd.service"
			ewarn "	* NetworkManager.service"
			ewarn "	* systemd-tmpfiles-setup.service"
			ewarn "	* systemd-tmpfiles-clean.service"
			ewarn "	* systemd-tmpfiles-clean.timer"
			ewarn "	* systemd-tmpfiles-setup-dev-early.service"
			ewarn "	* systemd-tmpfiles-setup-dev.service"
			ewarn "	* tmp.mount"
		fi
	fi
}

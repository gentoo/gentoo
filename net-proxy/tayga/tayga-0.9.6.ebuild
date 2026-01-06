# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Out-of-kernel stateless NAT64 implementation based on TUN"
HOMEPAGE="https://github.com/apalrd/tayga"
SRC_URI="https://github.com/apalrd/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

src_prepare() {
	default

	export prefix="${EPREFIX}/usr"
	export sysconfdir="${EPREFIX}/etc"
	export servicedir="$(systemd_get_systemunitdir)"

	# Unconditionally install init scripts
	export WITH_SYSTEMD=1
	export WITH_OPENRC=1
}

src_compile() {
	# Disable dynamic version detection
	emake TAYGA_VERSION="${PV}" TAYGA_BRANCH=main TAYGA_COMMIT=RELEASE
}

pkg_postinst() {
	local src="${EROOT}/var/db/tayga"
	local dst="${EROOT}/var/lib/tayga"

	if [[ -d "${src}" ]]; then
		einfo "${src} exists. Upstream moved the state directory"
		einfo "to ${dst}. Attempting to follow suit..."

		if [[ -e "${dst}" ]]; then
			ewarn "${dst} exists, skipping move."
		else
			mv -- "${src}" "${dst}" || ewarn "Move failed."
		fi
	fi
}

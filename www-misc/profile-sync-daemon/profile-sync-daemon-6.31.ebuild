# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

DESCRIPTION="Symlinks and syncs browser profile dirs to RAM."
HOMEPAGE="https://wiki.archlinux.org/index.php/Profile-sync-daemon"

SRC_URI="https://github.com/graysky2/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 x86"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	app-shells/bash
	net-misc/rsync[xattr]
	sys-apps/systemd"

pkg_postinst() {
	local replacing
	for replacing in ${REPLACING_VERSIONS}; do
		if [[ "$(get_major_version ${replacing})" == "5" ]]; then
			ewarn "${PN}-6 and later dropped OpenRC and /etc/psd.conf support"
			ewarn "See https://github.com/graysky2/profile-sync-daemon#note-for-version-6"
			break
		fi
	done
}

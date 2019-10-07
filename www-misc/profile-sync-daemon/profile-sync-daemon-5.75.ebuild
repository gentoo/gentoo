# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Symlinks and syncs browser profile dirs to RAM"
HOMEPAGE="https://wiki.archlinux.org/index.php/Profile-sync-daemon"
SRC_URI="https://github.com/graysky2/profile-sync-daemon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="systemd"

RDEPEND="
	app-shells/bash
	net-misc/rsync[xattr]
	systemd? ( sys-apps/systemd )"

PATCHES=(
	"${FILESDIR}/openrc-path.patch"
	"${FILESDIR}/bad-substitution-fix.patch"
)

src_install() {
	emake DESTDIR="${ED}" COMPRESS_MAN=0 \
		"$(usex systemd "install-systemd-all" "install-openrc-all")"

	use systemd || fperms -x /etc/cron.hourly/psd-update
}

pkg_postinst() {
	use systemd || elog "The cronjob is -x by default. You might want to set it +x."
}

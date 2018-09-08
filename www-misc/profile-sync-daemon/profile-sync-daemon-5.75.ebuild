# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Symlinks and syncs browser profile dirs to RAM"
HOMEPAGE="https://wiki.archlinux.org/index.php/Profile-sync-daemon"
SRC_URI="https://github.com/graysky2/profile-sync-daemon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd zsh-completion"

RDEPEND="
	app-shells/bash
	net-misc/rsync[xattr]
	systemd? ( sys-apps/systemd )"

PATCHES=(
	"${FILESDIR}/openrc-path.patch"
	"${FILESDIR}/bad-substitution-fix.patch"
)

src_install() {
	emake DESTDIR="${ED}" \
		install-openrc-all \
		$(usex systemd "install-systemd" "")

	if ! use zsh-completion; then
		rm -r "${ED}/usr/share/zsh" || die
	fi

	fperms -x /etc/cron.hourly/psd-update
}

pkg_postinst() {
	elog "The cronjob is -x by default."
	elog "You might want to set it +x if you don't use"
	elog "the systemd provided \"psd-resync.timer\"."
}

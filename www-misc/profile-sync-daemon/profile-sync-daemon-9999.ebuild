# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Symlinks and syncs browser profile dirs to RAM"
HOMEPAGE="https://wiki.archlinux.org/title/Profile-sync-daemon"
EGIT_REPO_URI="https://github.com/graysky2/${PN}"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	app-shells/bash
	net-misc/rsync[xattr]
	sys-apps/systemd"

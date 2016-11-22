# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="Symlinks and syncs browser profile dirs to RAM."
HOMEPAGE="https://wiki.archlinux.org/index.php/Profile-sync-daemon"
EGIT_REPO_URI="https://github.com/graysky2/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	app-shells/bash
	net-misc/rsync[xattr]
	sys-apps/systemd"

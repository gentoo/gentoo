# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/sw-notify-send/sw-notify-send-0.1.1.ebuild,v 1.2 2012/04/23 17:23:29 mgorny Exp $

EAPI=3
inherit autotools-utils

DESCRIPTION="A system-wide notification wrapper for notify-send"
HOMEPAGE="https://github.com/mgorny/sw-notify-send/"
SRC_URI="mirror://github/mgorny/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-process/procps"
DEPEND="${RDEPEND}"

# The lack of x11-libs/libnotify RDEPEND is intentional as:
# 1) The notification daemon may be running in a libnotify-enabled
# chroot system, while keeping the host system libnotify-free (in this
# case sw-notify-send enters the chroot first);
# 2) Having any kind of a notification daemon implies having libnotify
# installed. And if none is running, notify-send is not called anyway.

DOCS=( README )

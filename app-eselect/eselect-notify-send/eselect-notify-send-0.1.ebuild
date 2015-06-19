# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-notify-send/eselect-notify-send-0.1.ebuild,v 1.1 2015/03/31 16:52:10 ulm Exp $

EAPI=5

DESCRIPTION="Manage /usr/bin/notify-send symlink"
HOMEPAGE="http://www.gentoo.org/proj/en/eselect/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=">=app-eselect/eselect-lib-bin-symlink-0.1.1
	!<x11-libs/libnotify-0.7.5-r1"
DEPEND=${RDEPEND}

S=${FILESDIR}

src_install() {
	insinto /usr/share/eselect/modules
	newins notify-send.eselect-${PV} notify-send.eselect
}

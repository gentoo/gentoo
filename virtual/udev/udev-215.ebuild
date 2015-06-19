# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/udev/udev-215.ebuild,v 1.2 2014/08/03 12:29:47 ssuominen Exp $

EAPI=5

DESCRIPTION="Virtual to select between different udev daemon providers"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="systemd"

DEPEND=""
RDEPEND="
	!systemd? ( || ( >=sys-fs/udev-208-r1 >=sys-fs/eudev-1.3 ) )
	systemd? ( >=sys-apps/systemd-208:0 )"

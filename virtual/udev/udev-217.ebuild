# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual to select between different udev daemon providers"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="systemd"

DEPEND=""
RDEPEND="
	!systemd? ( || ( >=sys-fs/eudev-2.1.1 >=sys-fs/udev-217 ) )
	systemd? ( >=sys-apps/systemd-217:0 )"

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Preview a GRUB 2.x theme using KVM/QEMU"
HOMEPAGE="https://github.com/hartwork/grub2-theme-preview"
SRC_URI="https://github.com/hartwork/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-emulation/qemu
	dev-libs/libisoburn
	sys-fs/mtools
	sys-boot/grub:2[grub_platforms_pc]"

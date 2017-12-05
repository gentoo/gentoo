# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual for Linux kernel sources"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="firmware"

RDEPEND="
	firmware? ( sys-kernel/linux-firmware )
	|| (
		sys-kernel/gentoo-sources
		sys-kernel/vanilla-sources
		sys-kernel/ck-sources
		sys-kernel/git-sources
		sys-kernel/hardened-sources
		sys-kernel/mips-sources
		sys-kernel/openvz-sources
		sys-kernel/pf-sources
		sys-kernel/rt-sources
		sys-kernel/tuxonice-sources
		sys-kernel/xbox-sources
		sys-kernel/zen-sources
		sys-kernel/aufs-sources
		sys-kernel/raspberrypi-sources
	)"

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/libgudev/libgudev-215-r3.ebuild,v 1.1 2015/06/10 12:43:46 floppym Exp $

EAPI=5
inherit multilib-build

DESCRIPTION="Virtual for libgudev providers"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0/0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="introspection static-libs systemd"

DEPEND=""
RDEPEND="
	|| ( dev-libs/libgudev:0/0[${MULTILIB_USEDEP},introspection?,static-libs?]
		!systemd? ( || (
			>=sys-fs/udev-208-r1:0/0[${MULTILIB_USEDEP},gudev(-),introspection(-)?,static-libs?]
			>=sys-fs/eudev-1.5.3-r1:0/0[${MULTILIB_USEDEP},gudev(-),introspection(-)?,static-libs?] )
		)
		systemd? (
			>=sys-apps/systemd-212-r5:0/2[${MULTILIB_USEDEP},gudev(-),introspection(-)?]
		)
	)"

REQUIRED_USE="systemd? ( !static-libs )"

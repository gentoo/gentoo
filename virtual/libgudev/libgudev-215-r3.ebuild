# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit multilib-build

DESCRIPTION="Virtual for libgudev providers"
SLOT="0/0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sparc x86"
IUSE="introspection static-libs systemd"
REQUIRED_USE="systemd? ( !static-libs )"

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

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/dev-manager/dev-manager-0.ebuild,v 1.6 2014/01/18 18:52:24 vapier Exp $

EAPI="2"

DESCRIPTION="Virtual for the device filesystem manager"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="|| (
		virtual/udev
		sys-apps/busybox[mdev]
		sys-fs/devfsd
		sys-fs/static-dev
		sys-freebsd/freebsd-sbin
	)"

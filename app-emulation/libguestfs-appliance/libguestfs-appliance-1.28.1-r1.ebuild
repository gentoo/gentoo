# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CHECKREQS_DISK_USR=500M
CHECKREQS_DISK_BUILD=500M

inherit check-reqs

DESCRIPTION="VM appliance disk image used in libguestfs package"
HOMEPAGE="http://libguestfs.org/"
SRC_URI="http://libguestfs.org/download/binaries/appliance/appliance-${PV}.tar.xz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/xz-utils"
# Mixing libguestfs versions causes weird problems. #501588
RDEPEND="!<app-emulation/libguestfs-${PV}"

S="${WORKDIR}"

src_unpack() {
	# We'll unpack the tarball directly into ${D} to speed up install.
	# Otherwise we need to duplicate hundreds of data.
	:
}

src_install() {
	dodir /usr/share/guestfs
	cd "${ED}"/usr/share/guestfs
	unpack ${A}
	cd appliance || die
	dodoc README*
	# Don't rm README.* here, at least README.fixed is needed for libguestfs, see
	# https://bugzilla.redhat.com/show_bug.cgi?id=1183780
	chmod 755 . || die
	chmod 644 * || die

	newenvd "${FILESDIR}"/env.file 99"${PN}"
}

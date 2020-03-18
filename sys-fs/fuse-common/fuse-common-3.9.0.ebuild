# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev

DESCRIPTION="Common files for multiple slots of sys-fs/fuse"
HOMEPAGE="https://github.com/libfuse/libfuse"
SRC_URI="https://github.com/libfuse/libfuse/releases/download/fuse-${PV}/fuse-${PV}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"

BDEPEND="virtual/pkgconfig"
RDEPEND="!<sys-fs/fuse-2.9.7-r1:0"

S=${WORKDIR}/fuse-${PV}

src_install() {
	udev_newrules util/udev.rules 99-fuse.rules

	if use kernel_linux ; then
		newinitd "${FILESDIR}"/fuse.init fuse
	elif use kernel_FreeBSD ; then
		newinitd "${FILESDIR}"/fuse-fbsd.init fuse
	else
		die "We don't know what init code install for your kernel, please file a bug."
	fi

	insinto /etc
	doins util/fuse.conf
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson udev flag-o-matic

DESCRIPTION="Common files for multiple slots of sys-fs/fuse"
HOMEPAGE="https://github.com/libfuse/libfuse"
SRC_URI="https://github.com/libfuse/libfuse/releases/download/fuse-${PV}/fuse-${PV}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

DEPEND="virtual/pkgconfig"
RDEPEND="!<sys-fs/fuse-2.9.7-r1:0"

S=${WORKDIR}/fuse-${PV}

# tests run in sys-fs/fuse
RESTRICT="test"

src_prepare() {
	default

	# lto not supported yet -- https://github.com/libfuse/libfuse/issues/198
	filter-flags -flto*
}

src_install() {
	newsbin "${BUILD_DIR}"/util/mount.fuse3 mount.fuse
	doman doc/mount.fuse.8

	udev_newrules util/udev.rules 99-fuse.rules

	if use kernel_linux ; then
		newinitd "${FILESDIR}"/fuse.init fuse
	elif use kernel_FreeBSD ; then
		newinitd "${FILESDIR}"/fuse-fbsd.init fuse
	else
		die "We don't know what init code install for your kernel, please file a bug."
	fi

	dodir /etc
	cat > "${ED}"/etc/fuse.conf <<-EOF
		# Set the maximum number of FUSE mounts allowed to non-root users.
		# The default is 1000.
		#
		#mount_max = 1000

		# Allow non-root users to specify the 'allow_other' or 'allow_root'
		# mount options.
		#
		#user_allow_other
	EOF
}

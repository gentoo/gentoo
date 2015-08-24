# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

EGIT_REPO_URI="git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git"
inherit eutils toolchain-funcs flag-o-matic autotools

MY_PV="${PV/_/-}"
MY_P="util-linux-${MY_PV}"
LOOPAES_PV="${PV}-20120228"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Various useful Linux utilities"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/util-linux/"
SRC_URI="mirror://kernel/linux/utils/util-linux/v${PV:0:4}/${MY_P}.tar.xz
	http://loop-aes.sourceforge.net/updates/util-linux-${LOOPAES_PV}.diff.bz2"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-linux"

LICENSE="GPL-2 GPL-3 LGPL-2.1 BSD-4 MIT public-domain"
SLOT="0"
IUSE="nls selinux uclibc static"

RDEPEND="selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/os-headers"

src_prepare() {
	epatch "${WORKDIR}"/util-linux-*.diff
	use uclibc && sed -i -e s/versionsort/alphasort/g -e s/strverscmp.h/dirent.h/g mount/lomount.c
	eautoreconf
	elibtoolize
}

lfs_fallocate_test() {
	# Make sure we can use fallocate with LFS #300307
	cat <<-EOF > "${T}"/fallocate.c
	#define _GNU_SOURCE
	#include <fcntl.h>
	main() { return fallocate(0, 0, 0, 0); }
	EOF
	append-lfs-flags
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} "${T}"/fallocate.c -o /dev/null >/dev/null 2>&1 \
		|| export ac_cv_func_fallocate=no
	rm -f "${T}"/fallocate.c
}

src_configure() {
	lfs_fallocate_test
	econf \
		--disable-agetty \
		--disable-chsh-only-listed \
		--disable-cramfs \
		--disable-fallocate \
		--disable-fsck \
		--disable-kill \
		--disable-last \
		--disable-libmount \
		--disable-libmount-mount \
		--disable-libuuid \
		--disable-login-utils \
		--disable-makeinstall-chown \
		--disable-makeinstall-setuid \
		--disable-mesg \
		--disable-mountpoint \
		--disable-partx \
		--disable-pg-bell \
		--disable-pivot_root \
		--disable-raw \
		--disable-rename \
		--disable-require-password \
		--disable-reset \
		--disable-schedutils \
		--disable-switch_root \
		--disable-unshare \
		--disable-use-tty-group \
		--disable-uuidd \
		--disable-wall \
		--disable-write \
		--enable-libblkid \
		--enable-mount \
		--without-ncurses \
		--without-udev \
		$(use_enable nls) \
		$(use_with selinux) \
		$(tc-has-tls || echo --disable-tls) \
		$(use static && echo --enable-static-programs=losetup)
}

src_install() {
	emake install DESTDIR="${T}/root"
	newsbin "${T}/root/sbin/losetup" loop-aes-losetup
	use static && newsbin "${T}/root/bin/losetup.static" loop-aes-losetup.static
}

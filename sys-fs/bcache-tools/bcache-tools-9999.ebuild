# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_NONSHALLOW=true

inherit git-r3 toolchain-funcs udev

DESCRIPTION="Tools for bcachefs"
HOMEPAGE="http://bcache.evilpiepirate.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/g2p/bcache-tools.git"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
IUSE=""

RDEPEND=">=sys-apps/util-linux-2.24"
DEPEND="${RDEPEND}"

src_prepare() {
	tc-export CC
	sed \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^CFLAGS/s:-g:-std=gnu89:' \
		-i Makefile || die
}

src_install() {
	into /
	dosbin make-bcache bcache-super-show

	exeinto $(get_udevdir)
	doexe bcache-register probe-bcache

	udev_dorules 69-bcache.rules

	insinto /etc/initramfs-tools/hooks/bcache
	doins initramfs/hook

	insinto /etc/initcpio/install/bcache
	doins initcpio/install

	# that is what dracut does
	insinto /usr/lib/dracut/modules.d/90bcache
	doins dracut/module-setup.sh

	doman *.8

	dodoc README
}

pkg_postinst() {
	udev_reload
}

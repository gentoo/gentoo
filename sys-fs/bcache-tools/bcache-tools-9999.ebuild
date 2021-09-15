# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit flag-o-matic python-r1 toolchain-funcs udev

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git https://kernel.googlesource.com/pub/scm/linux/kernel/git/colyli/bcache-tools.git"
else
	SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/colyli/${PN}.git/snapshot/${P}.tar.gz"
fi

DESCRIPTION="Tools for bcache"
HOMEPAGE="https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git/"

SLOT="0"
LICENSE="GPL-2"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sys-apps/util-linux
	virtual/udev
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	tc-export CC
	sed \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^CFLAGS/s:-g::' \
		-i Makefile || die

	append-lfs-flags
}

src_install() {
	into /
	dosbin bcache make-bcache bcache-super-show

	exeinto $(get_udevdir)
	doexe bcache-register probe-bcache

	python_foreach_impl python_doscript bcache-status

	udev_dorules 69-bcache.rules

	insinto /etc/initramfs-tools/hooks/bcache
	doins initramfs/hook

	# that is what dracut does
	insinto /usr/lib/dracut/modules.d/90bcache
	doins dracut/module-setup.sh

	doman *.8

	dodoc README
}

pkg_postinst() {
	udev_reload
}

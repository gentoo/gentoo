# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit flag-o-matic python-r1 toolchain-funcs udev

DESCRIPTION="Tools for bcache"
HOMEPAGE="https://bcache.evilpiepirate.org/"
SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/colyli/${PN}.git/snapshot/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	sys-apps/util-linux"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/1.0.8_p20140220/bcache-tools-1.0.8-noprobe.patch
	"${FILESDIR}"/${PV}/bcache-tools-add-bcache-status.patch
	"${FILESDIR}"/${PV}/bcache-tools-add-man-page-bcache-status.8.patch
)

src_prepare() {
	eapply_user

	tc-export CC
	sed \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^CFLAGS/s:-g::' \
		-i Makefile || die

	append-lfs-flags

	eapply "${PATCHES[@]}"
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

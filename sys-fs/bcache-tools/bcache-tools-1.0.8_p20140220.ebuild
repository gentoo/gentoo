# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_{3,4,5} )

inherit eutils python-r1 toolchain-funcs udev

DESCRIPTION="Tools for bcachefs"
HOMEPAGE="http://bcache.evilpiepirate.org/"
SRC_URI="
	https://github.com/g2p/bcache-tools/archive/v${PV%%_p*}.tar.gz -> ${P}.tgz
	https://dev.gentoo.org/~jlec/distfiles/bcache-status-20140220.tar.gz
"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=sys-apps/util-linux-2.24"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PV}/bcache-status-python3.patch
	"${FILESDIR}"/${PV}/bcache-tools-1.0.8-crc64.patch
	"${FILESDIR}"/${PV}/bcache-tools-1.0.8-noprobe.patch
	"${FILESDIR}"/${PV}/bcache-tools-20131018-fedconf.patch
	"${FILESDIR}"/${PV}/bcache-tools-status-20130826-man.patch
	"${FILESDIR}"/${PV}/bcache-tools-1.0.8-probe-bcache-underlinking.patch
)

S="${WORKDIR}"/${P%%_p*}

src_prepare() {
	tc-export CC
	sed \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^CFLAGS/s:-g::' \
		-i Makefile || die

	cp ../bcache-status*/bcache-status .  || die

	epatch "${PATCHES[@]}"
}

src_install() {
	into /
	dosbin make-bcache bcache-super-show

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

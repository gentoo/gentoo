# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit edo systemd toolchain-funcs python-any-r1 udev

MY_PN="qemu"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="QEMU Guest Agent (qemu-ga) for use when running inside a VM"
HOMEPAGE="https://wiki.qemu.org/Features/GuestAgent"
SRC_URI="http://wiki.qemu.org/download/${MY_P}.tar.xz"

LICENSE="GPL-2 BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

RDEPEND="dev-libs/glib"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	dev-lang/perl
	dev-util/ninja"

S="${WORKDIR}/${MY_P}"

PATCHES=(
)

src_configure() {
	tc-export AR LD OBJCOPY RANLIB

	local myconf=(
		--prefix=/usr
		--sysconfdir=/etc
		--libdir="/usr/$(get_libdir)"
		--localstatedir=/
		--disable-bsd-user
		--disable-linux-user
		--disable-system
		--disable-strip
		--enable-tools
		--disable-werror
		--without-default-features
		--enable-guest-agent
		--python="${PYTHON}"
		--cc="$(tc-getCC)"
		--cxx="$(tc-getCXX)"
		--host-cc="$(tc-getBUILD_CC)"
	)

	edo ./configure "${myconf[@]}"
}

src_install() {
	dobin build/qga/qemu-ga

	# Normal init stuff
	newinitd "${FILESDIR}/qemu-ga.init-r1" qemu-guest-agent
	newconfd "${FILESDIR}/qemu-ga.conf-r1" qemu-guest-agent

	insinto /etc/logrotate.d
	newins "${FILESDIR}/qemu-ga.logrotate" qemu-guest-agent

	# systemd stuff
	udev_newrules "${FILESDIR}/qemu-ga-systemd.udev" 99-qemu-guest-agent.rules

	systemd_newunit "${FILESDIR}/qemu-ga-systemd.service" \
		qemu-guest-agent.service
}

pkg_postinst() {
	elog "You should add 'qemu-guest-agent' to the default runlevel."
	elog "e.g. rc-update add qemu-guest-agent default"
	udev_reload
}

pkg_postrm() {
	udev_reload
}

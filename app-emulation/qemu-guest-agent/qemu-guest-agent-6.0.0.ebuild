# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..11} )

inherit systemd toolchain-funcs udev python-any-r1

MY_PN="qemu"
MY_P="${MY_PN}-${PV}"

SRC_URI="http://wiki.qemu.org/download/${MY_P}.tar.xz"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

DESCRIPTION="QEMU Guest Agent (qemu-ga) for use when running inside a VM"
HOMEPAGE="https://wiki.qemu.org/Features/GuestAgent"

LICENSE="GPL-2 BSD-2"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/glib"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

S="${WORKDIR}/${MY_P}"

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
		--enable-guest-agent
		--python="${PYTHON}"
		--cc="$(tc-getCC)"
		--cxx="$(tc-getCXX)"
		--host-cc="$(tc-getBUILD_CC)"
	)
	echo "./configure ${myconf[*]}"
	./configure "${myconf[@]}" || die
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

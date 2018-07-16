# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit eutils systemd udev python-any-r1

MY_PN="qemu"
MY_P="${MY_PN}-${PV}"

SRC_URI="http://wiki.qemu.org/download/${MY_P}.tar.bz2"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~x86-fbsd"

DESCRIPTION="QEMU Guest Agent (qemu-ga) for use when running inside a VM"
HOMEPAGE="https://wiki.qemu.org/Features/GuestAgent"

LICENSE="GPL-2 BSD-2"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/glib
	x11-libs/pixman"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.0-sysmacros.patch #580924
)

src_configure() {
	tc-export AR LD OBJCOPY

	local myconf=(
		--prefix=/usr
		--sysconfdir=/etc
		--libdir="/usr/$(get_libdir)"
		--localstatedir=/
		--disable-bsd-user
		--disable-linux-user
		--disable-system
		--disable-strip
		--disable-tools
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

src_compile() {
	emake V=1 qemu-ga
}

src_install() {
	dobin qemu-ga

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
}

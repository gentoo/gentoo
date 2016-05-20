# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit eutils systemd udev python-any-r1

MY_PN="qemu"
MY_P="${MY_PN}-${PV}"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://git.qemu.org/qemu.git"
	inherit git-2
else
	SRC_URI="http://wiki.qemu.org/download/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
fi

DESCRIPTION="QEMU Guest Agent (qemu-ga) for use when running inside a VM"
HOMEPAGE="http://wiki.qemu.org/Features/QAPI/GuestAgent"

LICENSE="GPL-2 BSD-2"
SLOT="0"
IUSE=""

RDEPEND=">=dev-libs/glib-2.22
	!<app-emulation/qemu-1.1.1-r1
	!<sys-apps/sysvinit-2.88-r5"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.5.0-sysmacros.patch #580924
	epatch_user
}

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

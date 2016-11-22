# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit linux-info scons-utils toolchain-funcs systemd udev

MY_P=${PN}-linux-${PV}
DESCRIPTION="Userspace Xbox 360 Controller driver"
HOMEPAGE="http://pingus.seul.org/~grumbel/xboxdrv/"
SRC_URI="http://pingus.seul.org/~grumbel/xboxdrv/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/boost:=
	dev-libs/dbus-glib:=
	virtual/libudev:=
	sys-apps/dbus:=
	dev-libs/glib:2=
	virtual/libusb:1=
	x11-libs/libX11:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-scons.patch
	"${FILESDIR}"/github-144.patch
)

CONFIG_CHECK="~INPUT_EVDEV ~INPUT_JOYDEV ~INPUT_UINPUT ~!JOYSTICK_XPAD"

src_compile() {
	escons \
		BUILD=custom \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		CXXFLAGS="-Wall ${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}"
}

src_install() {
	dobin xboxdrv
	doman doc/xboxdrv.1
	dodoc AUTHORS NEWS PROTOCOL README.md TODO

	newinitd "${FILESDIR}"/xboxdrv.initd xboxdrv
	newconfd "${FILESDIR}"/xboxdrv.confd xboxdrv

	insinto /etc/dbus-1/system.d/
	doins "${FILESDIR}/org.seul.Xboxdrv.conf"

	udev_newrules "${FILESDIR}"/xboxdrv.udev-rules 99-xbox-controller.rules
	systemd_dounit "${FILESDIR}"/xboxdrv.service
}

pkg_postinst() {
	udev_reload
}

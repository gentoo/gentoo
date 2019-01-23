# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )

inherit linux-info python-any-r1 scons-utils toolchain-funcs systemd udev

COMMIT="0c0143b59b0fd9718af4968992c96b6b6b2a2557"
DESCRIPTION="Userspace Xbox 360 Controller driver"
HOMEPAGE="https://xboxdrv.gitlab.io"
SRC_URI="https://github.com/chewi/xboxdrv/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/boost:=
	dev-libs/dbus-glib
	dev-libs/glib:2
	sys-apps/dbus
	virtual/libudev:=
	virtual/libusb:1
	x11-libs/libX11
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${COMMIT}"

CONFIG_CHECK="~INPUT_EVDEV ~INPUT_JOYDEV ~INPUT_UINPUT ~!JOYSTICK_XPAD"

src_prepare() {
	default

	# Make it clearer that this is a patched fork.
	echo -n "${PV%_*}.${PV#*_p}-gentoo" > VERSION || die
}

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

	insinto /etc/dbus-1/system.d
	doins "${FILESDIR}"/org.seul.Xboxdrv.conf

	udev_newrules "${FILESDIR}"/xboxdrv.udev-rules 99-xbox-controller.rules
	systemd_dounit "${FILESDIR}"/xboxdrv.service
}

pkg_postinst() {
	udev_reload
}

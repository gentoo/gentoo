# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{3_3,3_4} )

inherit cmake-utils multilib eutils udev python-single-r1

DESCRIPTION="Utility for advanced configuration of Razer mice (DeathAdder, Krait, Lachesis)"

HOMEPAGE="http://bues.ch/cms/hacking/razercfg.html"
SRC_URI="http://bues.ch/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pm-utils qt4 systemd +udev"

RDEPEND="qt4? ( >=dev-python/pyside-1.2.1[${PYTHON_USEDEP}] )
	systemd? ( sys-apps/systemd )
	udev? ( virtual/udev )
	pm-utils? ( sys-power/pm-utils )
	virtual/libusb:1"

DEPEND="virtual/pkgconfig
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/libusb:1"

src_prepare() {
	sed -i \
		-e '/udevadm control/{N;d}' \
		-e '/systemctl/{N;d}' \
		-e "s:/etc/pm/sleep.d:/usr/$(get_libdir)/pm-utils/sleep.d/:" \
		-e 's:50-razer:80razer:' \
		CMakeLists.txt \
		|| die "sed failed"

	sed -i \
		-e '/ldconfig/{N;d}' \
		-e "s:DESTINATION lib:DESTINATION $(get_libdir):" \
		librazer/CMakeLists.txt \
		|| die "sed failed"
}

src_configure() {
	mycmakeargs="${mycmakeargs}	-DPYTHON='${PYTHON}'"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newinitd "${FILESDIR}"/razerd.init.d-r2 razerd
	dodoc README razer.conf

	if ! use qt4; then
		rm "${D}"/usr/bin/qrazercfg
	else
		make_desktop_entry qrazercfg "Razer Mouse Settings" mouse "Qt;Settings"
	fi

	use pm-utils || rm "${D}"/usr/$(get_libdir)/pm-utils/sleep.d/80razer
}

pkg_postinst() {
	use udev && udevadm control --reload-rules && udevadm trigger --subsystem-match=usb

	if [[ -e "${ROOT}"usr/bin/pyrazer.pyc ]]; then
		echo
		eerror "A stale ${ROOT}usr/bin/pyrazer.pyc exists and will prevent"
		eerror "the Python frontends from working until removed manually."
		echo
	fi
}

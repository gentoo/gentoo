# Copyright 2018-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd toolchain-funcs udev

DESCRIPTION="Led controller for Logitech G- Keyboards"
HOMEPAGE="https://github.com/MatMoul/g810-led"
SRC_URI="https://github.com/MatMoul/g810-led/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+hidapi"

RDEPEND="
	hidapi? ( dev-libs/hidapi:= )
	!hidapi? ( virtual/libusb:= )
	"
DEPEND="${RDEPEND}"

DOCS=("README.md" "sample_profiles" "sample_effects")

src_prepare() {
	default
	# See
	# https://github.com/systemd/systemd/issues/4288
	# https://sourceforge.net/p/sigrok/mailman/sigrok-devel/thread/12691365.gQiffmFRoU%40pebbles.site/
	# We remove the MODE-bit since it's already set to 660+GROUP="input" by default udev rules
	sed -i \
		-e 's|MODE="666"|TAG+="uaccess",|' \
		udev/g810-led.rules || die
}

src_compile() {
	emake LIB="$(usex hidapi hidapi libusb)" CXX="$(tc-getCXX)" bin-linked
}

src_install() {
	dolib.so "lib/libg810-led.so.${PV}"
	dosym "libg810-led.so.${PV}" "/usr/$(get_libdir)/libg810-led.so"

	insinto /etc/g810-led/
	newins sample_profiles/group_keys profile
	newins sample_profiles/all_off reboot

	dobin bin/g810-led
	local boards=(213 410 413 512 513 610 815 910 pro)
	local x
	for x in "${boards[@]}"; do
		dosym g810-led "/usr/bin/g${x}-led"
	done

	insinto /usr/include/g810-led
	doins src/classes/*.h

	systemd_dounit systemd/g810-led.service
	systemd_dounit systemd/g810-led-reboot.service

	udev_newrules udev/g810-led.rules 60-g810-led.rules

	einstalldocs
}

pkg_postinst() {
	elog "The file /etc/g810-led/profile is run on boot and device insertion."
	elog "The default file can be replaced by other examples:"
	elog "/usr/share/doc/${PF}/sample_profiles"
	elog "Read the documentation in:"
	elog "/usr/share/doc/${PF}/"
	elog "to make your own."
	if systemd_is_booted; then
		elog "To turn off the LEDs on shutdown and save power, do:"
		elog "systemctl enable g810-led-reboot.service"
	fi
}

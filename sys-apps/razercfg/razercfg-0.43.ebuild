# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit cmake python-single-r1 systemd tmpfiles udev xdg

DESCRIPTION="Utility for advanced configuration of Razer mice"
HOMEPAGE="https://bues.ch/cms/hacking/razercfg.html https://github.com/mbuesch/razer"
SRC_URI="https://bues.ch/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	virtual/libusb:1
"
RDEPEND="${DEPEND}
	virtual/udev
	gui? (
		$(python_gen_cond_dep '
			dev-python/pyqt5[${PYTHON_USEDEP}]
		')
	)
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	cmake_src_prepare

	# Don't clobber toolchain defaults
	sed -i -e '/-D_FORTIFY_SOURCE=2/d' scripts/cmake.global || die

	sed -i CMakeLists.txt \
		-e "s@/etc/udev/rules.d@$(get_udevdir)@" \
		-e "s@/usr/lib/systemd/system@$(systemd_get_systemunitdir)@" || die

	sed -i librazer/CMakeLists.txt \
		-e '/ldconfig/{N;d}' \
		-e "s:DESTINATION lib:DESTINATION $(get_libdir):" \
		|| die

	sed -i ui/razercfg.desktop.template \
		-e '/^Categories=/s/=.*$/=Qt;Settings/' \
		|| die

	export RAZERCFG_PKG_BUILD=1
}

src_configure() {
	local mycmakeargs=(
		-DPYTHON="${PYTHON}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	python_optimize

	newinitd "${FILESDIR}"/razerd.init.d-r2 razerd
	dodoc README.* HACKING.* razer.conf

	if ! use gui; then
		rm "${D}"/usr/bin/qrazercfg{,-applet} || die
		rm -r "${D}"/usr/share/{applications,icons} || die
	fi

	# sys-power/pm-utils is deprecated, so we delete related files
	# (they contain a hook for resume from suspend)
	# TODO: test resume from suspend
	rm -r "${D}/etc/pm" || die
}

pkg_postinst() {
	udevadm control --reload-rules
	udevadm trigger --subsystem-match=usb

	xdg_pkg_postinst

	tmpfiles_process razerd.conf

	if [[ -e "${ROOT}/usr/bin/pyrazer.pyc" ]]; then
		eerror "A stale ${ROOT}/usr/bin/pyrazer.pyc exists and will prevent"
		eerror "the Python frontends from working until removed manually."
	fi
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit cmake python-single-r1 systemd tmpfiles udev xdg-utils

DESCRIPTION="Utility for advanced configuration of Razer mice"
HOMEPAGE="https://bues.ch/cms/hacking/razercfg.html https://github.com/mbuesch/razer"
SRC_URI="https://bues.ch/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui +udev"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	virtual/libusb:1
"
BDEPEND="virtual/pkgconfig"
RDEPEND="${DEPEND}
	gui? (
		$(python_gen_cond_dep '
			dev-python/PyQt5[${PYTHON_USEDEP}]
		')
	)
	udev? ( virtual/udev )
"

PATCHES=( "${FILESDIR}/${PN}-0.39-unit-variables.patch" )

src_prepare() {
	cmake_src_prepare

	sed -i librazer/CMakeLists.txt \
		-e '/ldconfig/{N;d}' \
		-e "s:DESTINATION lib:DESTINATION $(get_libdir):" \
		|| die

	sed -i ui/razercfg.desktop.template \
		-e '/^Categories=/s/=.*$/=Qt;Settings/' \
		|| die
}

src_configure() {
	local mycmakeargs=(
		-DPYTHON="${PYTHON}"
		-DSYSTEMD_UNIT_DIR="$(systemd_get_systemunitdir)"
		-DUDEV_DIR="$(get_udevdir)"
	)
	RAZERCFG_PKG_BUILD=1 cmake_src_configure
}

src_install() {
	RAZERCFG_PKG_BUILD=1 cmake_src_install

	python_optimize

	newinitd "${FILESDIR}"/razerd.init.d-r2 razerd
	dodoc README.* HACKING.* razer.conf

	if ! use gui; then
		rm "${D}"/usr/bin/qrazercfg{,-applet} || die
		rm -r "${D}"/usr/share/icons || die
		rm -r "${D}"/usr/share/applications || die
	fi

	# sys-power/pm-utils is deprecated, so we delete related files
	# (they contain a hook for resume from suspend)
	# TODO: test resume from suspend
	rm -r "${D}/etc/pm" || die
}

pkg_postinst() {
	if use udev ; then
		udevadm control --reload-rules
		udevadm trigger --subsystem-match=usb
	fi

	xdg_icon_cache_update

	tmpfiles_process razerd.conf

	if [[ -e "${ROOT}/usr/bin/pyrazer.pyc" ]]; then
		eerror "A stale ${ROOT}/usr/bin/pyrazer.pyc exists and will prevent"
		eerror "the Python frontends from working until removed manually."
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
}

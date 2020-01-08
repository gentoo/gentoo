# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit eutils flag-o-matic linux-info python-single-r1 systemd xdg-utils

DESCRIPTION="decode and send infra-red signals of many commonly used remote controls"
HOMEPAGE="http://www.lirc.org/"

LIRC_DRIVER_DEVICE="/dev/lirc0"

MY_P=${PN}-${PV/_/-}

if [[ "${PV/_pre/}" = "${PV}" ]]; then
	SRC_URI="mirror://sourceforge/lirc/${MY_P}.tar.bz2"
else
	SRC_URI="http://www.lirc.org/software/snapshots/${MY_P}.tar.bz2"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 x86"
IUSE="audio +devinput doc ftdi gtk inputlirc static-libs systemd +uinput usb X"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	gtk? ( X )
"

S="${WORKDIR}/${MY_P}"

COMMON_DEPEND="
	${PYTHON_DEPS}
	audio? (
		>media-libs/portaudio-18
		media-libs/alsa-lib
	)
	dev-python/pyyaml[${PYTHON_USEDEP}]
	ftdi? ( dev-embedded/libftdi:0 )
	systemd? ( sys-apps/systemd )
	usb? ( virtual/libusb:0 )
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
	)
"

DEPEND="
	${COMMON_DEPEND}
	dev-libs/libxslt
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( app-doc/doxygen )
	sys-apps/kmod
	sys-kernel/linux-headers
"

RDEPEND="
	${COMMON_DEPEND}
	gtk? (
		x11-libs/vte[introspection]
		dev-python/pygobject[${PYTHON_USEDEP}]
	)
	inputlirc? ( app-misc/inputlircd )
"

PATCHES=(
	"${FILESDIR}/${P}-unsafe-load.patch"
)

MAKEOPTS+=" -j1"

pkg_setup() {
	use uinput && CONFIG_CHECK="~INPUT_UINPUT"
	python-single-r1_pkg_setup
	linux-info_pkg_setup
}

src_configure() {
	xdg_environment_reset
	econf \
		--localstatedir="${EPREFIX}/var" \
		$(use_enable static-libs static) \
		$(use_enable devinput) \
		$(use_enable uinput) \
		$(use_with X x)
}

src_install() {
	default

	if use !gtk ; then
		# lirc-setup requires gtk
		rm "${ED}"/usr/bin/lirc-setup || die
	fi

	newinitd "${FILESDIR}"/lircd-0.8.6-r2 lircd
	newinitd "${FILESDIR}"/lircmd-0.9.4a-r2 lircmd
	newconfd "${FILESDIR}"/lircd.conf.4 lircd
	newconfd "${FILESDIR}"/lircmd-0.10.0.conf lircmd

	insinto /etc/modprobe.d/
	newins "${FILESDIR}"/modprobed.lirc lirc.conf

	newinitd "${FILESDIR}"/irexec-initd-0.9.4a-r2 irexec
	newconfd "${FILESDIR}"/irexec-confd irexec

	keepdir /etc/lirc
	if [[ -e "${ED}"/etc/lirc/lircd.conf ]]; then
		newdoc "${ED}"/etc/lirc/lircd.conf lircd.conf.example
	fi

	find "${ED}" -name '*.la' -delete || die

	# Avoid QA notice
	rm -d "${ED}"/var/run/lirc || die
	rm -d "${ED}"/var/run || die
}

pkg_preinst() {
	local dir="${EROOT}/etc/modprobe.d"
	if [[ -a "${dir}"/lirc && ! -a "${dir}"/lirc.conf ]]; then
		elog "Renaming ${dir}/lirc to lirc.conf"
		mv -f "${dir}/lirc" "${dir}/lirc.conf" || die
	fi

	# copy the first file that can be found
	if [[ -f "${EROOT}"/etc/lirc/lircd.conf ]]; then
		cp "${EROOT}"/etc/lirc/lircd.conf "${T}"/lircd.conf || die
	elif [[ -f "${EROOT}"/etc/lircd.conf ]]; then
		cp "${EROOT}"/etc/lircd.conf "${T}"/lircd.conf || die
		MOVE_OLD_LIRCD_CONF=1
	elif [[ -f "${ED}"/etc/lirc/lircd.conf ]]; then
		cp "${ED}"/etc/lirc/lircd.conf "${T}"/lircd.conf || die
	fi

	# stop portage from touching the config file
	if [[ -e "${ED}"/etc/lirc/lircd.conf ]]; then
		rm -f "${ED}"/etc/lirc/lircd.conf || die
	fi
}

pkg_postinst() {
	# copy config file to new location
	# without portage knowing about it
	# so it will not delete it on unmerge or ever touch it again
	if [[ -e "${T}"/lircd.conf ]]; then
		cp "${T}"/lircd.conf "${EROOT}"/etc/lirc/lircd.conf || die
		if [[ "$MOVE_OLD_LIRCD_CONF" = "1" ]]; then
			elog "Moved /etc/lircd.conf to /etc/lirc/lircd.conf"
			rm -f "${EROOT}"/etc/lircd.conf || die
		fi
	fi

	einfo "The new default location for lircd.conf is inside of"
	einfo "${EROOT}/etc/lirc/ directory"
}

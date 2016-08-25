# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils flag-o-matic systemd

DESCRIPTION="decode and send infra-red signals of many commonly used remote controls"
HOMEPAGE="http://www.lirc.org/"

LIRC_DRIVER_DEVICE="/dev/lirc0"

MY_P=${PN}-${PV/_/}

if [[ "${PV/_pre/}" = "${PV}" ]]; then
	SRC_URI="mirror://sourceforge/lirc/${MY_P}.tar.bz2"
else
	SRC_URI="http://www.lirc.org/software/snapshots/${MY_P}.tar.bz2"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc static-libs X audio irman ftdi inputlirc iguanair systemd usb"

S="${WORKDIR}/${MY_P}"

REQUIRED_USE="
	iguanair? ( irman )
"
DEPEND="
	doc? ( app-doc/doxygen )
"

RDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libSM
		x11-libs/libICE
	)
	systemd? ( sys-apps/systemd )
	audio? (
		>media-libs/portaudio-18
		media-libs/alsa-lib
	)
	irman? ( media-libs/libirman )
	iguanair? ( app-misc/iguanaIR )
	ftdi? ( dev-embedded/libftdi:0 )
	inputlirc? ( app-misc/inputlircd )
	usb? ( virtual/libusb:0 )
"

PATCHES=(
	"${FILESDIR}"/lirc-0.9.4-doc-path-fix.patch # https://bugs.gentoo.org/show_bug.cgi?id=589246 https://sourceforge.net/p/lirc/tickets/214/
)

src_configure() {
	filter-flags -Wl,-O1
	econf \
		--localstatedir=/var \
		$(use_enable static-libs static) \
		$(use_with X x)
}

# Defined src_compile as a workaround for a parallel make issue
# See https://bugs.gentoo.org/show_bug.cgi?id=588864
# and https://sourceforge.net/p/lirc/tickets/210/
src_compile() {
	emake lib
	emake
}

src_install() {
	default

	newinitd "${FILESDIR}"/lircd-0.8.6-r2 lircd
	newinitd "${FILESDIR}"/lircmd-0.9.4a-r2 lircmd
	newconfd "${FILESDIR}"/lircd.conf.4 lircd
	newconfd "${FILESDIR}"/lircmd.conf lircmd

	insinto /etc/modprobe.d/
	newins "${FILESDIR}"/modprobed.lirc lirc.conf

	newinitd "${FILESDIR}"/irexec-initd-0.9.4a-r2 irexec
	newconfd "${FILESDIR}"/irexec-confd irexec

	keepdir /etc/lirc
	if [[ -e "${D}"/etc/lirc/lircd.conf ]]; then
		newdoc "${D}"/etc/lirc/lircd.conf lircd.conf.example
	fi

	find "${D}" -name '*.la' -delete || die

	# Avoid QA notice
	rm -d "${D}"/var/run/lirc || die
	rm -d "${D}"/var/run || die
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
	elif [[ -f "${D}"/etc/lirc/lircd.conf ]]; then
		cp "${D}"/etc/lirc/lircd.conf "${T}"/lircd.conf || die
	fi

	# stop portage from touching the config file
	if [[ -e "${D}"/etc/lirc/lircd.conf ]]; then
		rm -f "${D}"/etc/lirc/lircd.conf || die
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
	einfo "/etc/lirc/ directory"
}

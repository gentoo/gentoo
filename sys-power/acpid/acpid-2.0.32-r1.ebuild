# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit linux-info systemd

DESCRIPTION="Daemon for Advanced Configuration and Power Interface"
HOMEPAGE="https://sourceforge.net/projects/acpid2"
EXTRAS_VER="2.0.32-r1"
EXTRAS_NAME="${CATEGORY}_${PN}_${EXTRAS_VER}_extras"
SRC_URI="mirror://sourceforge/${PN}2/${P}.tar.xz
	https://dev.gentoo.org/~andrey_utkin/distfiles/${EXTRAS_NAME}.tar.xz
	"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~x86"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-apm )"
DEPEND=">=sys-kernel/linux-headers-3"

pkg_pretend() {
	local CONFIG_CHECK="~INPUT_EVDEV"
	local WARNING_INPUT_EVDEV="CONFIG_INPUT_EVDEV is required for ACPI button event support."
	[[ ${MERGE_TYPE} != buildonly ]] && check_extra_config
}

pkg_setup() { :; }

PATCHES=(
	"${WORKDIR}/${EXTRAS_NAME}/${PN}-2.0.32-powerbtn-gsd-power.patch" #702700
)

src_install() {
	emake DESTDIR="${D}" install

	newdoc kacpimon/README README.kacpimon
	dodoc -r samples
	rm -f "${D}"/usr/share/doc/${PF}/COPYING || die

	exeinto /etc/acpi
	newexe "${WORKDIR}/${EXTRAS_NAME}/${PN}-1.0.6-default.sh" default.sh
	exeinto /etc/acpi/actions
	newexe samples/powerbtn/powerbtn.sh powerbtn.sh
	insinto /etc/acpi/events
	newins "${WORKDIR}/${EXTRAS_NAME}/${PN}-1.0.4-default" default

	newinitd "${WORKDIR}/${EXTRAS_NAME}/${PN}-2.0.26-init.d" ${PN}
	newconfd "${WORKDIR}/${EXTRAS_NAME}/${PN}-2.0.16-conf.d" ${PN}

	systemd_dounit "${WORKDIR}"/${EXTRAS_NAME}/systemd/${PN}.{service,socket}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog
		elog "You may wish to read the Gentoo Linux Power Management Guide,"
		elog "which can be found online at:"
		elog "https://wiki.gentoo.org/wiki/Power_management/Guide"
		elog
	fi

	# files/systemd/acpid.socket -> ListenStream=/run/acpid.socket
	mkdir -p "${ROOT%/}"/run

	if ! grep -qs "^tmpfs.*/run " "${ROOT%/}"/proc/mounts ; then
		echo
		ewarn "You should reboot the system now to get /run mounted with tmpfs!"
	fi
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pax-utils systemd tmpfiles unpacker user

MY_PN="${PN/-bin/}"
BASE_URI="http://linux-packages.resilio.com/${MY_PN}/deb/pool/non-free/r/${MY_PN}/${MY_PN}_${PV}-1_-arch-.deb"
NAME="rslsync"

DESCRIPTION="Resilient, fast and scalable file synchronization tool"
HOMEPAGE="https://getsync.com/"
SRC_URI="amd64? ( ${BASE_URI/-arch-/amd64} )
	arm? ( ${BASE_URI/-arch-/armhf} )
	x86? ( ${BASE_URI/-arch-/i386} )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="pax_kernel"
RESTRICT="bindist mirror"

S="${WORKDIR}"

QA_PREBUILT="usr/bin/${NAME}"

pkg_setup() {
	enewgroup ${NAME}
	enewuser ${NAME} -1 -1 /var/lib/${MY_PN} ${NAME}
}

src_install() {
	dobin usr/bin/${NAME}
	use pax_kernel && pax-mark m "${ED%/}"/usr/bin/${NAME}

	doman usr/share/man/man1/${MY_PN}.1.gz

	dodir /var/log/${MY_PN}

	keepdir /etc/${MY_PN} /var/lib/${MY_PN} /var/lib/${MY_PN}/.sync
	fperms 0700 /etc/${MY_PN} /var/lib/${MY_PN} /var/lib/${MY_PN}/.sync \
		/var/log/${MY_PN}
	fowners -R ${NAME}:${NAME} /etc/${MY_PN} /var/lib/${MY_PN} \
		/var/log/${MY_PN}

	newtmpfiles "${FILESDIR}"/${MY_PN}.tmpfile ${MY_PN}.conf

	newinitd "${FILESDIR}"/${MY_PN}.initd ${MY_PN}
	newconfd "${FILESDIR}"/${MY_PN}.confd ${MY_PN}
	systemd_dounit lib/systemd/system/${MY_PN}.service
	systemd_douserunit usr/lib/systemd/user/${MY_PN}.service
}

pkg_preinst() {
	# Generate sample config
	"${ED%/}"/usr/bin/${NAME} --dump-sample-config > \
		"${ED%/}"/etc/${MY_PN}/config.json || die "config dump failed"
	fowners ${NAME}:${NAME} /etc/${MY_PN}/config.json
	# Uncomment config directives and change their values
	sed -i \
		-e "/storage_path/s|//| |g" \
		-e "/pid_file/s|//| |g" \
		-e "/storage_path/s|/home/user|/var/lib/resilio-sync|g" \
		-e "/pid_file/s|resilio|resilio-sync|g" \
		"${ED%/}"/etc/${MY_PN}/config.json || die "sed for pkg_preinst failed"
}

pkg_postinst() {
	tmpfiles_process ${MY_PN}.conf

	elog "You may need to review /etc/${MY_PN}/config.json"
	elog "Defalt metadata path is /var/lib/${MY_PN}/.sync"
	elog "Default web-gui URL is http://localhost:8888/"
	elog ""
	elog "You must be in the ${NAME} group to use Resilio Sync."
}

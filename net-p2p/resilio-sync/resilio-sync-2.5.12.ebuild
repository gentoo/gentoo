# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

BASE_URI="http://linux-packages.resilio.com/${PN}/deb/pool/non-free/r/${PN}/${PN}_${PV}-1_@arch@.deb"

inherit pax-utils readme.gentoo-r1 systemd tmpfiles unpacker user

NAME="rslsync"
QA_PREBUILT="usr/bin/${NAME}"

DESCRIPTION="Resilient, fast and scalable file synchronization tool"
HOMEPAGE="https://getsync.com/"
SRC_URI="amd64? ( ${BASE_URI/@arch@/amd64} )
	x86? ( ${BASE_URI/@arch@/i386} )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pax_kernel"
RESTRICT="mirror"

S="${WORKDIR}"

DOC_CONTENTS="You may need to review /etc/${PN}/config.json\n
Default metadata path is /var/lib/${PN}/.sync\n
Default web-gui URL is http://localhost:8888/\n\n"

pkg_setup() {
	enewgroup ${NAME}
	enewuser ${NAME} -1 -1 /var/lib/${PN} ${NAME}
}

src_unpack() {
	unpacker_src_unpack

	unpack usr/share/man/man1/${PN}.1.gz
}

src_install() {
	dobin usr/bin/${NAME}
	use pax_kernel && pax-mark m "${ED%/}"/usr/bin/${NAME}

	doman ${PN}.1

	dodir /var/log/${PN}
	keepdir /etc/${PN} /var/lib/${PN}/ /var/lib/${PN}/.sync
	fperms 0700 /etc/${PN} /var/lib/${PN} /var/lib/${PN}/.sync /var/log/${PN}
	fowners -R ${NAME}:${NAME} /etc/${PN} /var/lib/${PN} /var/log/${PN}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}-user.initd ${PN}-user
	newconfd "${FILESDIR}"/${PN}-user.confd ${PN}-user
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_douserunit "${FILESDIR}"/${PN}-user.service
	newtmpfiles "${FILESDIR}"/resilio-sync.tmpfile resilio-sync.conf

	readme.gentoo_create_doc

	# Generate sample config
	"${ED%/}"/usr/bin/${NAME} --dump-sample-config > \
		"${ED%/}"/etc/${PN}/config.json || die "generate config failed"
	fowners ${NAME}:${NAME} /etc/${PN}/config.json
	# Uncomment config directives and change their values
	sed -i \
		-e "/storage_path/s|//| |g" \
		-e "/pid_file/s|//| |g" \
		-e "/storage_path/s|/home/user/.sync|/var/lib/${PN}/.sync|g" \
		-e "/pid_file/s|resilio/resilio|${PN}/${PN}|g" \
		"${ED%/}"/etc/${PN}/config.json || die "sed failed for config.json"
}

pkg_postinst() {
	tmpfiles_process resilio-sync.conf
	readme.gentoo_print_elog
}

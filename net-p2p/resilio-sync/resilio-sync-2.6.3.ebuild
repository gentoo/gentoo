# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pax-utils readme.gentoo-r1 systemd tmpfiles unpacker user

QA_PREBUILT="usr/bin/rslsync"
BASE_URI="http://download-cdn.resilio.com/${PV}/Debian/${PN}_${PV}-1_@arch@.deb"

DESCRIPTION="Resilient, fast and scalable file synchronization tool"
HOMEPAGE="https://resilio.com/"
SRC_URI="amd64? ( ${BASE_URI/@arch@/amd64} )
	x86? ( ${BASE_URI/@arch@/i386} )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist mirror"

S="${WORKDIR}"

DOC_CONTENTS="You may need to review /etc/resilio-sync/config.json\\n
Default metadata path is /var/lib/resilio-sync/.sync\\n
Default web-gui URL is http://localhost:8888/\\n\\n"

pkg_setup() {
	enewgroup rslsync
	enewuser rslsync -1 -1 /var/lib/resilio-sync rslsync
}

src_unpack() {
	unpacker_src_unpack

	unpack usr/share/man/man1/resilio-sync.1.gz
}

src_install() {
	dobin usr/bin/rslsync
	pax-mark m "${ED}"/usr/bin/rslsync

	doman resilio-sync.1

	newinitd "${FILESDIR}"/resilio-sync.initd resilio-sync
	newconfd "${FILESDIR}"/resilio-sync.confd resilio-sync
	newinitd "${FILESDIR}"/resilio-sync-user.initd resilio-sync-user
	newconfd "${FILESDIR}"/resilio-sync-user.confd resilio-sync-user
	systemd_dounit "${FILESDIR}"/resilio-sync.service
	systemd_douserunit "${FILESDIR}"/resilio-sync-user.service
	newtmpfiles "${FILESDIR}"/resilio-sync.tmpfile resilio-sync.conf

	readme.gentoo_create_doc

	# Generate sample config, uncomment config directives and change values
	insopts -orslsync -grslsync -m0644
	insinto /etc/resilio-sync
	newins - config.json < <("${ED}"/usr/bin/rslsync --dump-sample-config | \
		sed \
			-e "/storage_path/s|//| |g" \
			-e "/pid_file/s|//| |g" \
			-e "/storage_path/s|/home/user/.sync|/var/lib/resilio-sync/.sync|g" \
			-e "/pid_file/s|resilio/resilio|resilio-sync/resilio-sync|g" \
			|| die "sed failed for config.json" )

	diropts -orslsync -grslsync -m0700
	keepdir /etc/resilio-sync /var/lib/resilio-sync/ \
		/var/lib/resilio-sync/.sync /var/log/resilio-sync
}

pkg_postinst() {
	tmpfiles_process resilio-sync.conf
	readme.gentoo_print_elog
}

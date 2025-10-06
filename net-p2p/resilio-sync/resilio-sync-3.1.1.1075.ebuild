# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo pax-utils readme.gentoo-r1 systemd tmpfiles

DESCRIPTION="Resilient, fast and scalable file synchronization tool"
HOMEPAGE="https://www.resilio.com"

if [[ ${PV} == 9999 ]]; then
	BDEPEND="net-misc/wget"
	PROPERTIES="live"
else
	BASE_URI="https://download-cdn.resilio.com/${PV}/linux/@arch@/0/${PN}_@arch@.tar.gz -> ${P}_@arch@.tar.gz"
	SRC_URI="
		amd64? ( ${BASE_URI//@arch@/x64} )
		arm64? ( ${BASE_URI//@arch@/arm64} )
	"
	KEYWORDS="-* ~amd64 ~arm64"
fi

S="${WORKDIR}"
LICENSE="all-rights-reserved"
SLOT="0"

RESTRICT="bindist mirror"

RDEPEND="
	acct-group/rslsync
	acct-user/rslsync
	virtual/libcrypt:=
"

QA_PREBUILT="usr/bin/rslsync"

DOC_CONTENTS="You may need to review /etc/resilio-sync/config.json\\n
Default metadata path is /var/lib/resilio-sync/.sync\\n
Default web-gui URL is http://localhost:8888/\\n\\n"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		local base_uri="https://download-cdn.resilio.com/stable/linux/@arch@/0/${PN}_@arch@.tar.gz"
		local uri
		if use amd64; then
			uri="${base_uri//@arch@/x64}"
		elif use arm64; then
			uri="${base_uri//@arch@/arm64}"
		else
			die "arch not supported"
		fi

		local dest="${T}/${PN}.tar.gz"
		edo wget -O "${dest}" "${uri}"
		unpack "${dest}"
	else
		default
	fi
}

src_install() {
	dobin rslsync
	pax-mark m "${ED}"/usr/bin/rslsync

	newinitd "${FILESDIR}"/resilio-sync.initd resilio-sync
	newconfd "${FILESDIR}"/resilio-sync.confd resilio-sync
	newinitd "${FILESDIR}"/resilio-sync-user.initd resilio-sync-user
	newconfd "${FILESDIR}"/resilio-sync-user.confd resilio-sync-user
	systemd_dounit "${FILESDIR}"/resilio-sync.service
	systemd_douserunit "${FILESDIR}"/resilio-sync-user.service
	newtmpfiles "${FILESDIR}"/resilio-sync.tmpfile resilio-sync.conf

	readme.gentoo_create_doc

	# Generate sample config, uncomment config directives and change values
	insopts -o rslsync -g rslsync -m 0644
	insinto /etc/resilio-sync
	newins - config.json < <("${ED}"/usr/bin/rslsync --dump-sample-config | \
		sed \
			-e "/storage_path/s|//| |g" \
			-e "/pid_file/s|//| |g" \
			-e "/storage_path/s|/home/user/.sync|/var/lib/resilio-sync/.sync|g" \
			-e "/pid_file/s|resilio/resilio|resilio-sync/resilio-sync|g" \
			|| die "sed failed for config.json" )

	diropts -o rslsync -g rslsync -m 0700
	keepdir /etc/resilio-sync /var/lib/resilio-sync/ \
		/var/lib/resilio-sync/.sync /var/log/resilio-sync
}

pkg_postinst() {
	tmpfiles_process resilio-sync.conf
	readme.gentoo_print_elog
}

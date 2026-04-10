# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/plexmediaserver.asc

inherit eapi9-pipestatus readme.gentoo-r1 systemd unpacker pax-utils verify-sig

MY_PV="${PV}-1e34174b1"
MY_URI="https://downloads.plex.tv/plex-media-server-new"

DESCRIPTION="Free media library that is intended for use with a plex client"
HOMEPAGE="https://www.plex.tv/"
SRC_URI="
	amd64? ( ${MY_URI}/${MY_PV}/debian/plexmediaserver_${MY_PV}_amd64.deb )
	arm? ( ${MY_URI}/${MY_PV}/debian/plexmediaserver_${MY_PV}_armhf.deb )
	arm64? ( ${MY_URI}/${MY_PV}/debian/plexmediaserver_${MY_PV}_arm64.deb )
	x86? ( ${MY_URI}/${MY_PV}/debian/plexmediaserver_${MY_PV}_i386.deb )
	verify-sig? (
		https://repo.plex.tv/deb/dists/public/InRelease -> ${P}-InRelease
		amd64? ( https://repo.plex.tv/deb/dists/public/main/binary-amd64/Packages -> ${P}-Packages.amd64 )
		arm? ( https://repo.plex.tv/deb/dists/public/main/binary-armhf/Packages -> ${P}-Packages.arm )
		arm64? ( https://repo.plex.tv/deb/dists/public/main/binary-arm64/Packages -> ${P}-Packages.arm64 )
		x86? ( https://repo.plex.tv/deb/dists/public/main/binary-i386/Packages -> ${P}-Packages.x86 )
	)
"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 ~arm arm64 ~x86"
IUSE="verify-sig"
RESTRICT="bindist"

DEPEND="
	acct-group/plex
	acct-user/plex"
RDEPEND="${DEPEND}"
BDEPEND="
	verify-sig? ( >=sec-keys/openpgp-keys-plexmediaserver-20240120 )
"

PATCHES=(
	"${FILESDIR}/${PN}.service.patch"
)

QA_DESKTOP_FILE="usr/share/applications/plexmediamanager.desktop"
QA_PREBUILT="*"
QA_MULTILIB_PATHS=(
	"usr/lib/plexmediaserver/lib/.*"
	"usr/lib/plexmediaserver/Resources/Python/lib/python2.7/.*"
	"usr/lib/plexmediaserver/Resources/Python/lib/python2.7/lib-dynload/_hashlib.so"
)

src_unpack() {
	if use verify-sig; then
		local deb_arch=${ARCH}
		[[ ${ARCH} == arm ]] && deb_arch=armhf
		[[ ${ARCH} == x86 ]] && deb_arch=i386

		cd "${DISTDIR}" > /dev/null || die

		# Verify APT chain of trust:
		# InRelease (signed) -> Packages (checksum) -> .deb (checksum)
		verify-sig_verify_message ${P}-InRelease - \
			| sed "s,[0-9]\+ main/binary-${deb_arch}/Packages$,${P}-Packages.${ARCH}," \
			| verify-sig_verify_unsigned_checksums - sha256 ${P}-Packages.${ARCH}
		pipestatus || die

		sed -n "/^Version: ${MY_PV}/,/^SHA256:/p" \
			${P}-Packages.${ARCH} \
			| sed "s,^SHA256: \(.*\),\1 plexmediaserver_${MY_PV}_${deb_arch}.deb," \
			| verify-sig_verify_unsigned_checksums - sha256 plexmediaserver_${MY_PV}_${deb_arch}.deb
		pipestatus || die

		cd "${WORKDIR}" > /dev/null || die
	fi

	unpacker_src_unpack
}

src_install() {
	# Remove Debian specific files
	rm -r "usr/share/doc" || die

	# Copy main files over to image and preserve permissions so it is portable
	cp -rp usr/ "${ED}" || die

	# Make sure the logging directory is created
	keepdir /var/log/pms
	fowners plex:plex /var/log/pms

	keepdir /var/lib/plexmediaserver
	fowners plex:plex /var/lib/plexmediaserver

	# Install the OpenRC init/conf files
	newinitd "${FILESDIR}/${PN}.init.d" ${PN}
	newconfd "${FILESDIR}/${PN}.conf.d" ${PN}

	# Install systemd service file
	systemd_newunit "${ED}"/usr/lib/plexmediaserver/lib/plexmediaserver.service "${PN}.service"

	# Add pax markings to some binaries so that they work on hardened setup
	BINS_TO_PAX_MARK=(
		"${ED}/usr/lib/plexmediaserver/Plex Script Host"
		"${ED}/usr/lib/plexmediaserver/Plex Media Scanner"
	)

	local f
	for f in "${BINS_TO_PAX_MARK[@]}"; do
		pax-mark m "${f}"
	done

	# Adds the precompiled plex libraries to the revdep-rebuild's mask list
	# so it doesn't try to rebuild libraries that can't be rebuilt.
	insinto /etc/revdep-rebuild
	doins "${FILESDIR}"/80plexmediaserver

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pax-utils systemd unpacker user

DESCRIPTION="A free media library that is intended for use with a plex client"
HOMEPAGE="https://www.plex.tv/"

_COMMIT="9311f93fd"
MY_PV="${PV}-${_COMMIT}"

URI="https://downloads.plex.tv/plex-media-server-new"
SRC_URI="
	amd64? ( ${URI}/${MY_PV}/debian/plexmediaserver_${MY_PV}_amd64.deb )
	x86? ( ${URI}/${MY_PV}/debian/plexmediaserver_${MY_PV}_i386.deb )"

LICENSE="Plex"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="mirror bindist strip"

BDEPEND="sys-apps/fix-gnustack"

QA_PREBUILT="*"
QA_MULTILIB_PATHS=( "usr/lib/plexmediaserver/lib/.*" )

S="${WORKDIR}"

PATCHES=( "${FILESDIR}/plexmediamanager.desktop.patch" )

pkg_setup() {
	enewgroup plex
	enewuser plex -1 /bin/bash /var/lib/plexmediaserver "plex,video"
}

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	# Move the config to the correct place
	local config_vanilla="/etc/default/plexmediaserver"
	local config_path="/etc/plex"
	dodir "${config_path}"
	insinto "${config_path}"
	doins "${config_vanilla#/}"
	sed -e "s#${config_vanilla}#${config_path}/$(basename "${config_vanilla}")#g" \
		-i "${S}"/usr/sbin/start_pms || die

	# Remove Debian specific files
	rm -r "${S}/usr/share/doc" || die

	# Copy main files over to image and preserve permissions so it is portable
	cp -rp usr/ "${ED}" || die

	# Make sure the logging directory is created
	keepdir /var/log/pms
	fowners plex:plex /var/log/pms

	keepdir /var/lib/plexmediaserver
	fowners plex:plex /var/lib/plexmediaserver

	doinitd "${FILESDIR}/init.d/${PN}"
	doconfd "${FILESDIR}/conf.d/${PN}"

	systemd_dounit "${FILESDIR}"/systemd/"${PN}".service

	keepdir /var/lib/plexmediaserver
	echo "export LD_LIBRARY_PATH=\"${EPREFIX}/usr/lib/plexmediaserver/lib\"" \
		> ${ED}/var/lib/plexmediaserver/.bash_profile || die

	# Adds the precompiled plex libraries to the revdep-rebuild's mask list
	# so it doesn't try to rebuild libraries that can't be rebuilt.
	dodir /etc/revdep-rebuild
	insinto /etc/revdep-rebuild
	doins "${FILESDIR}"/etc/revdep-rebuild/80plexmediaserver

	fix-gnustack -f "${ED%/}/usr/lib/plexmediaserver/lib/libgnsdk_dsp.so.3.10.1" || die

	pax-mark m "${ED%/}/usr/lib/plexmediaserver/Plex Script Host" || die
#	pax-mark m "${ED%/}/usr/lib/plexmediaserver/Plex Media Scanner" || die
}

pkg_postinst() {
	einfo ""
	elog "Plex Media Server is now installed. Please check the configuration file"
	elog "it can be found in /etc/plex/plexmediaserver to verify the default settings."
	elog "To start the Plex Server, run 'rc-config start plex-media-server'"
	elog "You will then be able to access your library at http://localhost:32400/manage"
}

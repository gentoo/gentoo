# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd unpacker user

DESCRIPTION="A free media library that is intended for use with a plex client"
HOMEPAGE="https://www.plex.tv/"

_APPNAME="plexmediaserver"
_USERNAME="plex"
_SHORTNAME="${_USERNAME}"
_COMMIT="9d51fdfaa"
_FULL_VERSION="${PV}-${_COMMIT}"

SRC_URI="
	amd64? ( https://downloads.plex.tv/${PN}/${_FULL_VERSION}/${_APPNAME}_${_FULL_VERSION}_amd64.deb )
	x86? ( https://downloads.plex.tv/${PN}/${_FULL_VERSION}/${_APPNAME}_${_FULL_VERSION}_i386.deb )"

LICENSE="Plex"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="mirror bindist strip"
IUSE="avahi system-openssl"

RDEPEND="avahi? ( net-dns/avahi )
	system-openssl? ( dev-libs/openssl:0 )"

QA_DESKTOP_FILE="usr/share/applications/plexmediamanager.desktop"
QA_PREBUILT="*"
QA_MULTILIB_PATHS=( "usr/lib/${_APPNAME}/.*" )

S="${WORKDIR}"

PATCHES=( "${FILESDIR}/plexmediamanager.desktop.patch" )

pkg_setup() {
	enewgroup ${_USERNAME}
	enewuser ${_USERNAME} -1 /bin/bash /var/lib/${_APPNAME} "${_USERNAME},video"
}

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	# Move the config to the correct place
	local config_vanilla="/etc/default/${_APPNAME}"
	local config_path="/etc/${_SHORTNAME}"
	dodir "${config_path}"
	insinto "${config_path}"
	doins "${config_vanilla#/}"
	sed -e "s#${config_vanilla}#${config_path}/$(basename "${config_vanilla}")#g" \
		-i "${S}"/usr/sbin/start_pms || die
	# Remove Debian specific files
	rm -r "usr/share/doc" || die
	# Remove buggy openssl library
	if use system-openssl; then
		rm -f usr/lib/plexmediaserver/libssl.so.1.0.0 || die
	fi
	# Copy main files over to image and preserve permissions so it is portable
	cp -rp usr/ "${ED}" || die
	# Make sure the logging directory is created
	local logging_dir="/var/log/pms"
	keepdir "${logging_dir}"
	fowners "${_USERNAME}":"${_USERNAME}" "${logging_dir}"
	# Create default library folder with correct permissions
	local default_library_dir="/var/lib/${_APPNAME}"
	keepdir "${default_library_dir}"
	fowners "${_USERNAME}":"${_USERNAME}" "${default_library_dir}"
	# Install the OpenRC init/conf files depending on avahi.
	if use avahi; then
		doinitd "${FILESDIR}/init.d/${PN}"
	else
		cp "${FILESDIR}/init.d/${PN}" "${T}/${PN}" || die
		sed -e '/depend/ s/^#*/#/' \
		-e '/need/ s/^#*/#/' \
		-e '1,/^}/s/^}/#}/' -i "${T}/${PN}" || die
		doinitd "${T}/${PN}"
	fi
	doconfd "${FILESDIR}/conf.d/${PN}"
	# Install systemd service file
	systemd_dounit "${FILESDIR}"/systemd/"${PN}".service
	keepdir /var/lib/${_APPNAME}
	echo "export LD_LIBRARY_PATH=\"${EPREFIX}/usr/lib/${_APPNAME}\"" \
		> ${ED}/var/lib/${_APPNAME}/.bash_profile || die
#	insinto "${ED}/var/lib/${_APPNAME}/" && doins - .bash_profile <<- _EOF_
#	export LD_LIBRARY_PATH=\"${EPREFIX}/usr/lib/${_APPNAME}\"
#		_EOF_
	# Adds the precompiled plex libraries to the revdep-rebuild's mask list
	# so it doesn't try to rebuild libraries that can't be rebuilt.
	dodir /etc/revdep-rebuild/
	echo "SEARCH_DIRS_MASK=\"${EPREFIX}/usr/$(get_libdir)/${_APPNAME}\"" \
		> ${ED}/etc/revdep-rebuild/80${_APPNAME} || die
#	insinto "${D}"/etc/revdep-rebuild && doins - 80"${_APPNAME}" <<- _EOF_
#	SEARCH_DIRS_MASK=\"${EPREFIX}/usr/$(get_libdir)/${_APPNAME}\"
#		_EOF_
}

pkg_postinst() {
	einfo ""
	elog "Plex Media Server is now installed. Please check the configuration file"
	elog "it can be found in /etc/${_SHORTNAME}/${_APPNAME} to verify the default settings."
	elog "To start the Plex Server, run 'rc-config start plex-media-server'"
	elog "You will then be able to access your library at http://<ip>:32400/web/index.html"
}

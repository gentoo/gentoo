# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit eutils systemd unpacker pax-utils python-single-r1

MINOR_VERSION="1469-6d5612c2f"

_APPNAME="plexmediaserver"
_USERNAME="plex"
_SHORTNAME="${_USERNAME}"
_FULL_VERSION="${PV}.${MINOR_VERSION}"

URI="https://downloads.plex.tv/plex-media-server-new"

DESCRIPTION="A free media library that is intended for use with a plex client"
HOMEPAGE="https://www.plex.tv/"
SRC_URI="amd64? ( ${URI}/${_FULL_VERSION}/debian/plexmediaserver_${_FULL_VERSION}_amd64.deb )"
SLOT="0"
LICENSE="Plex"
RESTRICT="bindist strip"
KEYWORDS="-* ~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="dev-python/virtualenv[${PYTHON_USEDEP}]"

RDEPEND="
	net-dns/avahi
	acct-user/plex
	acct-group/plex
	${PYTHON_DEPS}"

QA_PREBUILT="*"
QA_MULTILIB_PATHS=(
	"usr/lib/${_APPNAME}/.*"
	"usr/lib/${_APPNAME}/Resources/Python/lib/python2.7/.*"
)

BINS_TO_PAX_MARK=( "${ED}/usr/lib/plexmediaserver/Plex Script Host" )

S="${WORKDIR}"
PATCHES=( "${FILESDIR}/virtualenv_start_pms_2019.patch" )

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	# Move the config to the correct place
	local config_vanilla="/etc/default/plexmediaserver"
	local config_path="/etc/${_SHORTNAME}"
	dodir "${config_path}"
	insinto "${config_path}"
	doins "${config_vanilla#/}"
	sed -e "s#${config_vanilla}#${config_path}/${_APPNAME}#g" -i "${S}"/usr/sbin/start_pms || die

	# Remove Debian specific files
	rm -r "usr/share/doc" || die

	# Fix QA warning about .desktop file.
	sed -i 's|Audio;Music;Video;Player;Media;|AudioVideo;Music;Player;|g' \
		usr/share/applications/plexmediaserver.desktop || die

	# Copy main files over to image and preserve permissions so it is portable
	cp -rp usr/ "${ED}"/ || die

	# Make sure the logging directory is created
	local logging_dir="/var/log/pms"
	dodir "${logging_dir}"
	fowners "${_USERNAME}":"${_USERNAME}" "${logging_dir}"
	keepdir "${logging_dir}"

	# Create default library folder with correct permissions
	local default_library_dir="/var/lib/${_APPNAME}"
	dodir "${default_library_dir}"
	fowners "${_USERNAME}":"${_USERNAME}" "${default_library_dir}"
	keepdir "${default_library_dir}"

	# Install the OpenRC init/conf files
	doinitd "${FILESDIR}/init.d/${PN}"
	doconfd "${FILESDIR}/conf.d/${PN}"

	# Mask Plex libraries so that revdep-rebuild doesn't try to rebuild them.
	# Plex has its own precompiled libraries.
	_mask_plex_libraries_revdep

	# Install systemd service file
	systemd_newunit "${FILESDIR}/systemd/${PN}.service" "${PN}.service"

	# Add pax markings to some binaries so that they work on hardened setup
	for f in "${BINS_TO_PAX_MARK[@]}"; do
		pax-mark m "${f}"
	done

	einfo "Configuring virtualenv"
	virtualenv -v --no-pip --no-setuptools --no-wheel "${ED}"/usr/lib/plexmediaserver/Resources/Python || die
	pushd "${ED}"/usr/lib/plexmediaserver/Resources/Python &>/dev/null || die
	find . -type f -exec sed -i -e "s#${D}##g" {} + || die
	popd &>/dev/null || die
}

pkg_postinst() {
	elog "Plex Media Server is now installed. Please check the configuration"
	elog "file in /etc/${_SHORTNAME}/${_APPNAME}"
	elog "to verify the default settings."
	elog "To start the Plex Server, run 'rc-config start plex-media-server',"
	elog "you will then be able to access your library at"
	elog "http://<ip>:32400/web/"
}

# Adds the precompiled plex libraries to the revdep-rebuild's mask list
# so it doesn't try to rebuild libraries that can't be rebuilt.
_mask_plex_libraries_revdep() {
	dodir /etc/revdep-rebuild/

	# Bug: 659702. The upstream plex binary installs its precompiled package to /usr/lib.
	# Due to profile 17.1 splitting /usr/lib and /usr/lib64, we can no longer rely
	# on the implicit symlink automatically satisfying our revdep requirement when we use $(get_libdir).
	# Thus we will match upstream's directory automatically. If upstream switches their location,
	# then so should we.
	echo "SEARCH_DIRS_MASK=\"${EPREFIX}/usr/lib/plexmediaserver\"" > "${ED}"/etc/revdep-rebuild/80plexmediaserver
}

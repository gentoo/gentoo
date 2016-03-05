# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kde-workspace"
inherit systemd kde4-meta flag-o-matic user

DESCRIPTION="KDE login manager, similar to xdm and gdm"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +consolekit kerberos pam systemd"

REQUIRED_USE="consolekit? ( !systemd ) systemd? ( !consolekit )"

DEPEND="
	$(add_kdebase_dep libkworkspace)
	media-libs/qimageblitz
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXtst
	consolekit? (
		>=sys-apps/dbus-1.0.2
		sys-auth/consolekit
	)
	kerberos? ( virtual/krb5 )
	pam? (
		$(add_kdebase_dep kcheckpass)
		virtual/pam
	)
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kdepasswd)
	$(add_kdebase_dep libkgreeter)
	>=x11-apps/xinit-1.0.5-r2
	x11-apps/xmessage
"

KMEXTRACTONLY="
	libs/kdm/kgreeterplugin.h
"

PATCHES=(
	"${FILESDIR}/${PN}-4-gentoo-xinitrc.d.patch"
)

pkg_setup() {
	kde4-meta_pkg_setup

	# Create kdm:kdm user
	KDM_HOME=/var/lib/kdm
	enewgroup kdm
	enewuser kdm -1 -1 "${KDM_HOME}" kdm
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use kerberos KDE4_KRB5AUTH)
		$(cmake-utils_use_with pam)
		$(cmake-utils_use_with consolekit CkConnector)
	)

	kde4-meta_src_configure
}

src_install() {
	export GENKDMCONF_FLAGS="--no-old --no-backup"

	kde4-meta_src_install

	# an equivalent file is already installed by kde-base/startkde, bug 377151
	rm "${ED}/usr/share/apps/kdm/sessions/kde-plasma.desktop" || die

	# Customize the kdmrc configuration:
	# - SessionDirs set to /usr/share/xsessions
	# - increase server timeout to 30s
	# - TerminateServer=true to workaround X server regen bug, bug 278473
	# - DataDir set to /var/lib/kdm
	# - FaceDir set to /var/lib/kdm/faces
	sed -e "s|^.*SessionsDirs=.*$|#&\nSessionsDirs=${EPREFIX}/usr/share/apps/kdm/sessions,${EPREFIX}/usr/share/xsessions|" \
		-e "/#ServerTimeout=/s/^.*$/ServerTimeout=30/" \
		-e "/#TerminateServer=/s/^.*$/TerminateServer=true/" \
		-e "s|^.*DataDir=.*$|#&\nDataDir=${EPREFIX}${KDM_HOME}|" \
		-e "s|^.*FaceDir=.*$|#&\nFaceDir=${EPREFIX}${KDM_HOME}/faces|" \
		-i "${ED}"/usr/share/config/kdm/kdmrc \
		|| die "Failed to set ServerTimeout and SessionsDirs correctly in kdmrc."

	# Don't install empty dir
	rmdir "${ED}"/usr/share/config/kdm/sessions

	# Set up permissions to kdm work directory
	keepdir "${KDM_HOME}"
	fowners root:kdm "${KDM_HOME}"
	fperms 1770 "${KDM_HOME}"

	# install logrotate file
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/kdm-logrotate kdm

	systemd_dounit "${FILESDIR}"/kdm.service
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	local file src dest dir old_dirs=(
		/var/lib/kdm-live
		/var/lib/kdm-4.6
		/var/lib/kdm-4.5
		/var/lib/kdm-4.4
		/usr/share/apps/kdm
		/usr/kde/4.4/share/apps/kdm
		/usr/kde/4.3/share/apps/kdm
		/usr/kde/4.2/share/apps/kdm
	)

	mkdir -p "${EROOT}${KDM_HOME}/faces"
	# Set the default kdm face icon if it's not already set by the system admin
	# because this is user-overrideable in that way, it's not in src_install
	for file in faces/.default.face.icon:default1.png faces/root.face.icon:root1.png kdmsts: ; do
		src=${file#*:}
		dest=${file%:*}
		if [[ ! -e ${EROOT}${KDM_HOME}/$dest ]]; then
			for dir in "${old_dirs[@]}"; do
				if [[ -e ${EROOT}${dir}/${dest} ]]; then
					cp "${EROOT}${dir}/${dest}" "${EROOT}${KDM_HOME}/${dest}"
					break 2
				fi
			done
			if [[ -n ${src} ]]; then
				cp "${EROOT}/usr/share/apps/kdm/pics/users/${src}" \
					"${EROOT}${KDM_HOME}/${dest}"
			fi
		fi
	done
	for dir in "${old_dirs[@]}"; do
		if [[ ${dir} != /usr/* && -d ${EROOT}${dir} ]]; then
			echo
			elog "The directory ${EROOT%/}${dir} still exists from an older installation of KDE."
			elog "You may wish to copy relevant settings into ${EROOT%/}${KDM_HOME}."
			echo
			elog "After doing so, you may delete the directory."
			echo
		fi
	done

	# Make sure permissions are correct -- old installations may have
	# gotten this wrong
	use prefix || chown root:kdm "${EROOT}${KDM_HOME}"
	chmod 1770 "${EROOT}${KDM_HOME}"

	if use consolekit; then
		echo
		elog "You have compiled 'kdm' with consolekit support. If you want to use kdm,"
		elog "make sure consolekit daemon is running and started at login time"
		elog
		elog "rc-update add consolekit default && /etc/init.d/consolekit start"
		echo
	fi
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils pam systemd versionator

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/axs-gentoo/slim-git.git"
	inherit git-r3
else
	SRC_URI="mirror://sourceforge/project/${PN}.berlios/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
fi

DESCRIPTION="Simple Login Manager"
HOMEPAGE="https://sourceforge.net/projects/slim.berlios/"
LICENSE="GPL-2"
SLOT="0"
IUSE="branding pam consolekit"
REQUIRED_USE="consolekit? ( pam )"

RDEPEND="x11-libs/libXmu
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXft
	x11-libs/libXrandr
	media-libs/libpng:0=
	virtual/jpeg:=
	x11-apps/sessreg
	consolekit? ( sys-auth/consolekit
		sys-apps/dbus )
	pam? ( sys-libs/pam
		!x11-misc/slimlock )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto"
PDEPEND="branding? ( >=x11-themes/slim-themes-1.2.3a-r3 )"

PATCHES=(
	# Our Gentoo-specific config changes
	"${FILESDIR}"/${P}-config.diff
)

src_prepare() {
	cmake-utils_src_prepare

	if use elibc_FreeBSD; then
		sed -i -e 's/"-DHAVE_SHADOW"/"-DNEEDS_BASENAME"/' CMakeLists.txt \
			|| die
	fi

	if use branding; then
		sed -i -e '/current_theme/s/default/slim-gentoo-simple/' slim.conf \
			|| die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DUSE_PAM=$(usex pam)
		-DUSE_CONSOLEKIT=$(usex consolekit)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use pam ; then
		pamd_mimic system-local-login slim auth account session
		pamd_mimic system-local-login slimlock auth
	fi

	systemd_dounit build_files/slim.service

	insinto /usr/share/slim
	newins "${FILESDIR}/Xsession-r3" Xsession

	insinto /etc/logrotate.d
	newins "${FILESDIR}/slim.logrotate" slim

	dodoc xinitrc.sample README THEMES
}

pkg_postinst() {
	# massage ${REPLACING_VERSIONS} to come up with whether or not it's a new install
	# or if it's older than 1.3.2-r7
	# Note - there should only ever be zero or one version as this package isn't slotted,
	# so the logic doesn't worry about what happens if there's two, due to the case where
	# a previous emerge attempt failed in the middle of qmerge.
	local rv=none
	for rv in ${REPLACING_VERSIONS} ; do
		if version_is_at_least "1.3.2-r7" "${rv}" ; then
			rv=newer
			break;
		fi
		if version_is_at_least "1.0" "${rv}"  ; then
			rv=older
			break;
		fi
	done

	if [[ ${rv} == none ]]; then
		elog
		elog "The configuration file is located at /etc/slim.conf."
		elog
		elog "If you wish ${PN} to start automatically, set DISPLAYMANAGER=\"${PN}\" "
		elog "in /etc/conf.d/xdm and run \"rc-update add xdm default\"."
	fi
	if [[ ${rv} != newer ]]; then
		elog
		elog "By default, ${PN} is set up to provide X session selection based on the"
		elog ".desktop entries in /usr/share/xsessions/ that are installed by each"
		elog "DE, including ~/.xsession support via the 'Xsession' session.  Sessions"
		elog "are selected at login by pressing [F1].  As per the Xorg guide, each"
		elog "user's default session can be specified by adding the name from"
		elog "/etc/X11/Sessions to ~/.xsession."
		elog
		elog "The XSESSION environment variable is still supported as a default"
		elog "if no session has been specified by the user."
		elog
		elog "If you want to use .xinitrc in the user's home directory for session"
		elog "management instead, see README and xinitrc.sample in"
		elog "/usr/share/doc/${PF} and change your login_cmd in /etc/slim.conf"
		elog "accordingly."
		elog
		ewarn "Please note that slim supports consolekit directly.  Please do not use any "
		ewarn "old work-arounds (including calls to 'ck-launch-session' in xinitrc scripts)"
		ewarn "and enable USE=\"consolekit\" instead."
		ewarn
	fi
	if ! use pam; then
		elog "You have merged ${PN} without USE=\"pam\", this will cause ${PN} to fall back to"
		elog "the console when restarting your window manager. If this is not desired, then"
		elog "please remerge ${PN} with USE=\"pam\""
		elog
	fi
}

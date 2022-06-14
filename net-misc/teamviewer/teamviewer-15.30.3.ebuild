# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop optfeature systemd xdg

MY_MAJOR="$(ver_cut 1)"
MY_P="${PN}${MY_MAJOR}"
DESCRIPTION="All-In-One Solution for Remote Access and Support over the Internet"
HOMEPAGE="https://www.teamviewer.com"
MY_URI="https://dl.tvcdn.de/download/linux/version_${MY_MAJOR}x/${PN}_${PV}"
SRC_URI="amd64? ( ${MY_URI}_amd64.tar.xz )
		arm? ( ${MY_URI}_armhf.tar.xz )
		arm64? ( ${MY_URI}_arm64.tar.xz )
		x86? ( ${MY_URI}_i386.tar.xz )"
S="${WORKDIR}"/teamviewer

LICENSE="TeamViewer MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist mirror"

# Unpack will fail without app-arch/xz-utils[extra-filters], bug #798027
BDEPEND="app-arch/xz-utils[extra-filters]"

RDEPEND="
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libglvnd[X]
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	sys-libs/zlib:0/1[minizip]
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/libxkbcommon[X]
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm
"
# For consolekit incompatibility see https://forums.gentoo.org/viewtopic-p-8332956.html#8332956

QA_PREBUILT="opt/${MY_P}/*"

src_prepare() {
	default

	# Switch operation mode from 'portable' to 'installed'
	sed -e "s/TAR_NI/TAR_IN/g" -i tv_bin/script/tvw_config || die

	sed -i \
		-e "/^ExecStart/s|${PN}|${MY_P}|" \
		-e "/^PIDFile/s|/var/run/|/run/|" \
		tv_bin/script/teamviewerd.service || die
}

src_install() {
	local dst="/opt/${MY_P}" # install destination

	insinto ${dst}
	doins -r tv_bin

	# Set permissions for executables and libraries
	local exe
	for exe in $(find tv_bin -type f -executable -or -name '*.so' || die); do
		fperms +x ${dst}/${exe}
	done

	newinitd "${FILESDIR}"/teamviewerd15.init teamviewerd
	systemd_dounit tv_bin/script/teamviewerd.service

	insinto /usr/share/dbus-1/services
	doins tv_bin/script/com.teamviewer.TeamViewer.service
	doins tv_bin/script/com.teamviewer.TeamViewer.Desktop.service

	insinto /usr/share/polkit-1/actions
	doins tv_bin/script/com.teamviewer.TeamViewer.policy

	local size
	for size in 16 24 32 48 256; do
		newicon -s ${size} tv_bin/desktop/teamviewer_${size}.png teamviewer.png
	done

	dodoc -r doc

	# Make docs available in expected location
	dosym ../../usr/share/doc/${PF}/doc ${dst}/doc

	# We need to keep docs uncompressed, bug #778617
	docompress -x /usr/share/doc/${PF}/.

	keepdir /etc/${MY_P}
	dosym ../../etc/${MY_P} ${dst}/config

	# Create directory and symlink for log files (NOTE: according to Team-
	# Viewer devs, all paths are hard-coded in the binaries; therefore
	# using the same path as the DEB/RPM archives, i.e. '/var/log/teamviewer
	# <major-version>')
	keepdir /var/log/${MY_P}
	dosym ../../var/log/${MY_P} ${dst}/logfiles

	dodir /opt/bin
	dosym ${dst}/tv_bin/teamviewerd /opt/bin/teamviewerd
	dosym ${dst}/tv_bin/script/teamviewer /opt/bin/teamviewer

	make_desktop_entry teamviewer "TeamViewer ${MY_MAJOR}"
}

pkg_postinst() {
	xdg_pkg_postinst

	ewarn
	ewarn "Please note that the teamviewer gui works only when started from"
	ewarn "a session initiated by a display manager." #799137
	optfeature_header "Install one of the following display managers:"
	optfeature "an example display manager" x11-misc/cdm gnome-base/gdm gui-apps/gtkgreet x11-misc/lightdm lxde-base/lxdm sys-apps/qingy x11-misc/sddm x11-misc/slim x11-misc/wdm x11-apps/xdm

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog
		elog "Please note that parallel installation of multiple versions of"
		elog "TeamViewer is currently not supported at runtime. Bug #621818"
		elog
		elog "Before using TeamViewer, you need to start its daemon:"
		elog "OpenRC:"
		elog "# /etc/init.d/teamviewerd start"
		elog "# rc-update add teamviewerd default"
		elog
		elog "Systemd:"
		elog "# systemctl start teamviewerd.service"
		elog "# systemctl enable teamviewerd.service"
		elog
		elog "To display additional command line options simply run:"
		elog "$ teamviewer help"
		elog
		elog "Most likely TeamViewer will work normally only on systems with systemd"
		elog "or elogind. See this thread for additional info:"
		elog "https://forums.gentoo.org/viewtopic-p-8332956.html#8332956"
	fi
}

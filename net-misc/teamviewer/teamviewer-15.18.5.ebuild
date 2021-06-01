# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_MAJOR="$(ver_cut 1)"
MY_P="${PN}${MY_MAJOR}"
inherit desktop systemd xdg

DESCRIPTION="All-In-One Solution for Remote Access and Support over the Internet"
HOMEPAGE="https://www.teamviewer.com"
SRC_URI="amd64? ( https://dl.tvcdn.de/download/linux/version_${MY_MAJOR}x/${PN}_${PV}_amd64.tar.xz )
		x86? ( https://dl.tvcdn.de/download/linux/version_${MY_MAJOR}x/${PN}_${PV}_i386.tar.xz )"

LICENSE="TeamViewer MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	sys-apps/dbus
	!sys-auth/consolekit
"

# For consolekit incompatibility see https://forums.gentoo.org/viewtopic-p-8332956.html#8332956

RESTRICT="bindist mirror"

# Silence QA messages
QA_PREBUILT="opt/${MY_P}/*"

S="${WORKDIR}"/teamviewer

src_prepare() {
	default

	# Switch operation mode from 'portable' to 'installed'
	sed -e "s/TAR_NI/TAR_IN/g" -i tv_bin/script/tvw_config || die

	sed -i \
		-e "/^ExecStart/s/${PN}/${MY_P}/" \
		tv_bin/script/teamviewerd.service || die
}

src_install() {
	local dst="/opt/${MY_P}" # install destination

	# Quirk:
	# Remove Intel 80386 32-bit ELF binary 'libdepend' present in all
	# archives. It will trip the 'emerge @preserved-libs' logic on amd64
	# when changing the ABI of one of its dependencies. According to the
	# TeamViewer devs, this binary is an unused remnant of previous Wine-
	# based builds and will be removed in future releases anyway
	rm tv_bin/script/libdepend

	insinto ${dst}
	doins -r tv_bin

	# Set permissions for executables and libraries
	local exe
	for exe in $(find tv_bin -type f -executable -or -name '*.so'); do
		fperms 755 ${dst}/${exe}
	done

	# No slotting here, binary expects this service path
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
	docompress -x /usr/share/doc/${PF}/*

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

	make_desktop_entry teamviewer "TeamViewer ${MY_MAJOR}" teamviewer
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation

		elog "Please note that parallel installation of multiple versions of"
		elog "TeamViewer is currently not supported at runtime. Bug #621818"
		elog ""
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

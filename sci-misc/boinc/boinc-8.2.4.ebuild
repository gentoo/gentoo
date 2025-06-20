# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_cut 1-2)
WX_GTK_VER=3.2-gtk3

inherit autotools bash-completion-r1 linux-info optfeature wxwidgets xdg-utils

DESCRIPTION="The Berkeley Open Infrastructure for Network Computing"
HOMEPAGE="https://boinc.berkeley.edu/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/BOINC/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/BOINC/boinc/archive/client_release/${MY_PV}/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-client_release-${MY_PV}-${PV}"

	# We don't mark "stable" and "alpha" release channels in any special way but
	# use stable/testing keywords instead.
	#
	# "Alpha" versions are only named as such, they are actually more like beta
	# versions or release candidates.
	# https://github.com/BOINC/boinc/wiki/AlphaInstructions
	#
	# The current versions for each of release channels can be found at:
	# https://boinc.berkeley.edu/linux_install.php
	KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="LGPL-3+"
SLOT="0"

# - "X" builds idle tracking via XScrnSaver and the libboinc_graphics2 library
# - "gui" builds the manager app and the screensaver
IUSE="X gui"

DEPEND="
	>=acct-user/boinc-1
	app-misc/ca-certificates
	dev-libs/openssl:=
	net-misc/curl[ssl]
	sys-libs/zlib:=
	X? (
		media-libs/freeglut
		media-libs/libjpeg-turbo:=
		x11-libs/libX11
		x11-libs/libXScrnSaver
	)
	gui? (
		dev-libs/glib:2
		x11-libs/gtk+:3
		x11-libs/libnotify
		x11-libs/libxcb:=
		x11-libs/wxGTK:${WX_GTK_VER}=[opengl,webkit]
		x11-libs/xcb-util
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/docbook-xml-dtd:4.4
	app-text/docbook2X
	virtual/pkgconfig
"

pkg_setup() {
	# Bug 578750
	if use kernel_linux; then
		linux-info_pkg_setup
		if ! linux_config_exists; then
			ewarn "Can't check the linux kernel configuration."
			ewarn "You might be missing vsyscall support."
		elif kernel_is -ge 4 4 \
			&& linux_chkconfig_present LEGACY_VSYSCALL_NONE; then
			ewarn "You do not have vsyscall emulation enabled."
			ewarn "This will prevent some boinc projects from running."
			ewarn "Please enable vsyscall emulation:"
			ewarn "    CONFIG_LEGACY_VSYSCALL_EMULATE=y"
			ewarn "in /usr/src/linux/.config, to be found at"
			ewarn "    Processor type and features --->"
			ewarn "        vsyscall table for legacy applications (None) --->"
			ewarn "            (X) Emulate"
			ewarn "Alternatively, you can enable CONFIG_LEGACY_VSYSCALL_NATIVE."
			ewarn "However, this has security implications and is not recommended."
		fi
	fi
}

src_prepare() {
	default

	# prevent bad changes in compile flags, bug 286701
	sed -i -e "s:BOINC_SET_COMPILE_FLAGS::" configure.ac || die "sed failed"

	eautoreconf
}

src_configure() {
	use gui && setup-wxwidgets

	local myeconfargs=(
		--disable-server
		--enable-client
		--enable-dynamic-client-linkage
		--enable-unicode
		--with-ssl
		$(usex X "" ax_cv_check_glut_libglut="no")
		$(use_with X x)
		$(use_enable gui manager)
		$(usex gui --with-wx-config="${WX_CONFIG}" --without-wxdir)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# cleanup cruft
	rm -r "${ED}"/etc || die "rm failed"
	find "${D}/usr/$(get_libdir)" -name '*.la' -delete || die "Removing .la files failed"
	find "${D}/usr/$(get_libdir)" -name '*.a' -delete || die "Removing static libs failed"

	newbashcomp client/scripts/boinc.bash boinc
	bashcomp_alias boinc boinccmd

	keepdir /var/lib/boinc
	fowners boinc:boinc /var/lib/boinc
	fperms 750 /var/lib/boinc

	dosym -r /etc/ssl/certs/ca-certificates.crt /var/lib/boinc/ca-bundle.crt

	exeinto /etc/X11/xinit/xinitrc.d
	newexe packages/generic/36x11-common_xhost-boinc 95-boinc

	newinitd "${FILESDIR}"/boinc.initd-r1 boinc
	newconfd "${FILESDIR}"/boinc.confd-r1 boinc
}

pkg_postinst() {
	if use gui; then
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
		xdg_icon_cache_update
	fi

	elog
	elog "You need to attach to a project to do anything useful with boinc."
	elog "You can do this by running:"
	elog "# rc-service boinc attach"
	elog "The user manual is located at:"
	elog "https://github.com/BOINC/boinc/wiki/User-manual"
	elog
	# Add warning about the new password for the client, bug 121896.
	if use gui; then
		elog "If you need to use the graphical manager, the password is in:"
		elog "/var/lib/boinc/gui_rpc_auth.cfg"
		elog "Where /var/lib/boinc is default RUNTIMEDIR that can be changed in:"
		elog "/etc/conf.d/boinc"
		elog "You should change this password to something more memorable (can be even blank)."
		elog "Remember to launch init script before using manager. Or changing the password."
		elog
	fi

	# OpenCL and CUDA libraries are loaded with dlopen(),
	# no headers used at build time and no linking occurs.
	optfeature "CUDA applications support" x11-drivers/nvidia-drivers
	optfeature "Docker applications support" \
		"app-containers/podman app-containers/podman-compose" \
		"app-containers/docker app-containers/docker-compose:2"
	optfeature "OpenCL applications support" virtual/opencl
	optfeature "VirtualBox applications support" app-emulation/virtualbox

	optfeature_header "If you want to run ATLAS native tasks by LHC@home, you need to install:"
	optfeature "CERN VM filesystem support" net-fs/cvmfs
}

pkg_postrm() {
	if use gui; then
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
		xdg_icon_cache_update
	fi
}

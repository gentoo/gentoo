# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_cut 1-2)
WX_GTK_VER=3.0-gtk3

inherit autotools desktop flag-o-matic linux-info optfeature wxwidgets xdg-utils

DESCRIPTION="The Berkeley Open Infrastructure for Network Computing"
HOMEPAGE="https://boinc.berkeley.edu/"

SRC_URI="X? ( https://boinc.berkeley.edu/logo/boinc_glossy2_512_F.tif -> ${PN}.tif )"
if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/BOINC/${PN}.git"
	inherit git-r3
else
	SRC_URI+=" https://github.com/BOINC/boinc/archive/client_release/${MY_PV}/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
	S="${WORKDIR}/${PN}-client_release-${MY_PV}-${PV}"
fi

LICENSE="LGPL-3"
SLOT="0"

IUSE_VIDEO_CARDS="
		video_cards_amdgpu
		video_cards_intel
		video_cards_nvidia
		video_cards_radeonsi
"

IUSE="${IUSE_VIDEO_CARDS} X cuda curl_ssl_gnutls +curl_ssl_openssl opencl"

REQUIRED_USE="
	^^ ( curl_ssl_gnutls curl_ssl_openssl )
	cuda? ( video_cards_nvidia )
	opencl? ( || ( ${IUSE_VIDEO_CARDS} ) )
"

# libcurl must not be using an ssl backend boinc does not support.
# If the libcurl ssl backend changes, boinc should be recompiled.
DEPEND="
	acct-user/boinc
	app-misc/ca-certificates
	cuda? (
		x11-drivers/nvidia-drivers
	)
	opencl? (
		virtual/opencl
		video_cards_amdgpu?   ( amd64? ( dev-libs/rocm-opencl-runtime ) )
		video_cards_intel?    ( amd64? ( dev-libs/intel-compute-runtime ) )
		video_cards_nvidia?   ( x11-drivers/nvidia-drivers )
		video_cards_radeonsi? ( media-libs/mesa[opencl] )
	)
	dev-libs/openssl:=
	net-misc/curl[curl_ssl_gnutls(-)=,-curl_ssl_nss(-),curl_ssl_openssl(-)=,-curl_ssl_axtls(-),-curl_ssl_cyassl(-)]
	sys-libs/zlib
	X? (
		dev-libs/glib:2
		media-libs/freeglut
		media-libs/libjpeg-turbo:=
		x11-libs/gtk+:3
		x11-libs/libnotify
		x11-libs/libX11
		x11-libs/libXScrnSaver
		x11-libs/libxcb:=
		x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,webkit]
		x11-libs/xcb-util
	)
"
BDEPEND="app-text/docbook-xml-dtd:4.4
	app-text/docbook2X
	sys-devel/gettext
	X? ( virtual/imagemagick-tools[png,tiff] )
"
RDEPEND="
	${DEPEND}
	sys-apps/util-linux
	!app-admin/quickswitch
"

PATCHES=(
	# >=x11-libs/wxGTK-3.0.2.0-r3 has webview removed, bug 587462
	"${FILESDIR}"/${PN}-7.18-fix_webview.patch
)

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
	use X && setup-wxwidgets

	append-libs -L"${ESYSROOT}"/usr/$(get_libdir) -L"${ESYSROOT}"/$(get_libdir)

	econf --disable-server \
		--enable-client \
		--enable-dynamic-client-linkage \
		--disable-static \
		--enable-unicode \
		--with-ssl \
		$(use_with X x) \
		$(use_enable X manager) \
		$(usex X --with-wx-config="${WX_CONFIG}" --without-wxdir)
}

src_install() {
	default

	keepdir /var/lib/${PN}

	if use X; then
		# Create new icons. bug 593362
		local s SIZES=(16 22 24 32 36 48 64 72 96 128 192 256)
		for s in "${SIZES[@]}"; do
			# The convert command is not checked, because it will issue warnings and exit with
			# an error code if imagemagick is used and was merged with USE="-xml", although the
			# conversion has worked. See #766093
			# Instead, newicon will fail if the conversion did not produce the icon.
			convert "${DISTDIR}"/${PN}.tif -resize ${s}x${s} "${WORKDIR}"/boinc_${s}.png
			newicon -s $s "${WORKDIR}"/boinc_${s}.png boinc.png
		done
		make_desktop_entry boincmgr "${PN}" "${PN}" "Math;Science" "Path=/var/lib/${PN}"

		# Rename the desktop file to boincmgr.desktop to (hot)fix bug 599910
		mv "${ED}"/usr/share/applications/boincmgr{-${PN},}.desktop || \
			die "Failed to rename desktop file"
	fi

	# cleanup cruft
	rm -r "${ED}"/etc || die "rm failed"
	find "${D}" -name '*.la' -delete || die "Removing .la files failed"

	newinitd ${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}
}

pkg_postinst() {
	if use X; then
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
		xdg_icon_cache_update
	fi

	elog
	elog "You are using the source compiled version of boinc."
	use X && elog "The graphical manager can be found at /usr/bin/boincmgr"
	elog
	elog "You need to attach to a project to do anything useful with boinc."
	elog "You can do this by running /etc/init.d/boinc attach"
	elog "The howto for configuration is located at:"
	elog "http://boinc.berkeley.edu/wiki/Anonymous_platform"
	elog
	# Add warning about the new password for the client, bug 121896.
	if use X; then
		elog "If you need to use the graphical manager the password is in:"
		elog "/var/lib/boinc/gui_rpc_auth.cfg"
		elog "Where /var/lib/ is default RUNTIMEDIR, that can be changed in:"
		elog "/etc/conf.d/boinc"
		elog "You should change this password to something more memorable (can be even blank)."
		elog "Remember to launch init script before using manager. Or changing the password."
		elog
	fi
	elog "To be able to use CUDA or OpenCL you should add the boinc user to the video group."
	elog "Run as root:"
	elog "gpasswd -a boinc video"
	elog

	optfeature_header "If you want to run ATLAS native tasks by LHC@home, you need to install:"
	optfeature "CERN VM filesystem support" net-fs/cvmfs
}

pkg_postrm() {
	if use X; then
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
		xdg_icon_cache_update
	fi
}

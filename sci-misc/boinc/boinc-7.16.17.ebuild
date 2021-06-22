# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_cut 1-2)
WX_GTK_VER=3.0-gtk3

inherit autotools desktop flag-o-matic linux-info systemd wxwidgets xdg-utils

DESCRIPTION="The Berkeley Open Infrastructure for Network Computing"
HOMEPAGE="https://boinc.ssl.berkeley.edu/"

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
IUSE="X cuda curl_ssl_gnutls +curl_ssl_openssl"

REQUIRED_USE="^^ ( curl_ssl_gnutls curl_ssl_openssl ) "

# libcurl must not be using an ssl backend boinc does not support.
# If the libcurl ssl backend changes, boinc should be recompiled.
COMMON_DEPEND="
	acct-group/boinc
	acct-user/boinc
	>=app-misc/ca-certificates-20080809
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-2.1
		>=x11-drivers/nvidia-drivers-180.22
	)
	net-misc/curl[curl_ssl_gnutls(-)=,-curl_ssl_nss(-),curl_ssl_openssl(-)=,-curl_ssl_axtls(-),-curl_ssl_cyassl(-)]
	sys-apps/util-linux
	sys-libs/zlib
	X? (
		dev-db/sqlite:3
		media-libs/freeglut
		virtual/jpeg:0=
		x11-libs/gtk+:3
		x11-libs/libICE
		>=x11-libs/libnotify-0.7
		x11-libs/libSM
		x11-libs/libXi
		x11-libs/libXmu
		x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,webkit]
		virtual/jpeg
	)
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.4
	app-text/docbook2X
	sys-devel/gettext
	X? ( virtual/imagemagick-tools[png,tiff] )
"
RDEPEND="${COMMON_DEPEND}
	!app-admin/quickswitch
"

PATCHES=(
	# >=x11-libs/wxGTK-3.0.2.0-r3 has webview removed, bug 587462
	"${FILESDIR}"/${PN}-${MY_PV}-fix_webview.patch
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
	# bug #732024
	if test "x$(get_libdir)" = "xlib64"; then
	    sed -i -e 's,/:/lib:/usr/lib:,:/lib64:/usr/lib64:,g' m4/sah_check_lib.m4 || die
	fi

	default

	# prevent bad changes in compile flags, bug 286701
	sed -i -e "s:BOINC_SET_COMPILE_FLAGS::" configure.ac || die "sed failed"

	eautoreconf

	# bug #732024
	if test "x$(get_libdir)" = "xlib64"; then
	    sed -i -e 's,/lib\([ /;:"]\),/lib64\1,g' configure || die
	fi
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

	sed -e "s/@libdir@/$(get_libdir)/" "${FILESDIR}"/${PN}.init.in > ${PN}.init || die
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
	# Add information about BOINC supporting OpenCL
	elog "BOINC supports OpenCL. To use it you have to eselect"
	if use cuda; then
		elog "nvidia as the OpenCL implementation, as you are using CUDA."
	else
		elog "the correct OpenCL implementation for your graphic card."
	fi
	elog
}

pkg_postrm() {
	if use X; then
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
		xdg_icon_cache_update
	fi
}

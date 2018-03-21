# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER=3.0-gtk3

inherit autotools eutils gnome2-utils linux-info systemd user wxwidgets

MY_PV="7.10"

DESCRIPTION="The Berkeley Open Infrastructure for Network Computing"
HOMEPAGE="http://boinc.ssl.berkeley.edu/"
SRC_URI="https://github.com/BOINC/boinc/archive/client_release/${MY_PV}/${PV}.tar.gz -> ${P}.tar.gz
	X? ( https://boinc.berkeley.edu/logo/boinc_glossy2_512_F.tif -> ${PN}.tif )"
RESTRICT="mirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="X cuda curl_ssl_gnutls curl_ssl_libressl +curl_ssl_openssl"

REQUIRED_USE="^^ ( curl_ssl_gnutls curl_ssl_libressl curl_ssl_openssl ) "

# libcurl must not be using an ssl backend boinc does not support.
# If the libcurl ssl backend changes, boinc should be recompiled.
COMMON_DEPEND="
	>=app-misc/ca-certificates-20080809
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-2.1
		>=x11-drivers/nvidia-drivers-180.22
	)
	net-misc/curl[curl_ssl_gnutls(-)=,curl_ssl_libressl(-)=,-curl_ssl_nss(-),curl_ssl_openssl(-)=,-curl_ssl_axtls(-),-curl_ssl_cyassl(-)]
	sys-apps/util-linux
	sys-libs/zlib
	X? (
		dev-db/sqlite:3
		media-libs/freeglut
		virtual/jpeg:0=
		x11-libs/gtk+:3
		>=x11-libs/libnotify-0.7
		x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,webkit]
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
	"${FILESDIR}"/fix_webview.patch
	# xlocale.h was removed in modern glibc, bug 639108
	"${FILESDIR}"/${MY_PV}-fix_xlocale.patch
)

S="${WORKDIR}/${PN}-client_release-${MY_PV}-${PV}"

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

	use X && need-wxwidgets unicode
}

src_configure() {
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
			convert "${DISTDIR}"/${PN}.tif -resize ${s}x${s} "${WORKDIR}"/boinc_${s}.png || die
			newicon -s $s "${WORKDIR}"/boinc_${s}.png boinc.png
		done
		make_desktop_entry boincmgr "${PN}" "${PN}" "Math;Science" "Path=/var/lib/${PN}"

		# Rename the desktop file to boincmgr.desktop to (hot)fix bug 599910
		mv "${ED%/}"/usr/share/applications/boincmgr{-${PN},}.desktop || \
			die "Failed to rename desktop file"
	fi

	# cleanup cruft
	rm -rf "${ED%/}"/etc || die "rm failed"
	find "${D}" -name '*.la' -delete || die "Removing .la files failed"

	sed -e "s/@libdir@/$(get_libdir)/" "${FILESDIR}"/${PN}.init.in > ${PN}.init || die
	newinitd ${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_preinst() {
	gnome2_icon_savelist

	enewgroup ${PN}
	# note this works only for first install so we have to
	# elog user about the need of being in video group
	local groups="${PN}"
	if use cuda; then
		groups+=",video"
	fi
	enewuser ${PN} -1 -1 /var/lib/${PN} "${groups}"
}

pkg_postinst() {
	if [[ -n ${GNOME2_ECLASS_ICONS} ]]; then
		gnome2_icon_cache_update
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
	if use cuda; then
		elog "To be able to use CUDA you should add boinc user to video group."
		elog "Run as root:"
		elog "gpasswd -a boinc video"
		elog
	fi
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
	if [[ -n ${GNOME2_ECLASS_ICONS} ]]; then
		gnome2_icon_cache_update
	fi
}

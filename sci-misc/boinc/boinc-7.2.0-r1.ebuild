# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/boinc/boinc-7.2.0-r1.ebuild,v 1.2 2015/08/04 13:28:13 mgorny Exp $

EAPI=5

#WANT_AUTOMAKE="1.11"

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils flag-o-matic eutils wxwidgets user systemd

DESCRIPTION="The Berkeley Open Infrastructure for Network Computing"
HOMEPAGE="http://boinc.ssl.berkeley.edu/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="X cuda static-libs"

RDEPEND="
	!sci-misc/boinc-bin
	!app-admin/quickswitch
	>=app-misc/ca-certificates-20080809
	dev-libs/openssl:0=
	net-misc/curl[ssl,-gnutls(-),-nss(-),curl_ssl_openssl(+)]
	sys-apps/util-linux
	sys-libs/zlib
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-2.1
		>=x11-drivers/nvidia-drivers-180.22
	)
	X? (
		dev-db/sqlite:3
		media-libs/freeglut
		sys-libs/glibc:2.2
		virtual/jpeg:0=
		x11-libs/gtk+:2
		>=x11-libs/libnotify-0.7
		x11-libs/wxGTK:2.8[X,opengl]
	)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	app-text/docbook-xml-dtd:4.4
	app-text/docbook2X
"

PATCHES=(
	"${FILESDIR}"/${P}-fix_subdirs.patch
)

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	# prevent bad changes in compile flags, bug 286701
	sed -i -e "s:BOINC_SET_COMPILE_FLAGS::" configure.ac || die "sed failed"

	autotools-utils_src_prepare
}

src_configure() {
	local wxconf=""

	# add gtk includes
	append-flags "$(pkg-config --cflags gtk+-2.0)"

	# look for wxGTK
	if use X; then
		WX_GTK_VER="2.8"
		need-wxwidgets unicode
		wxconf+=" --with-wx-config=${WX_CONFIG}"
	else
		wxconf+=" --without-wxdir"
	fi

	local myeconfargs=(
		--disable-server
		--enable-client
		--enable-dynamic-client-linkage
		--disable-static
		--enable-unicode
		--with-ssl
		$(use_with X x)
		$(use_enable X manager)
		${wxconf}
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	dodir /var/lib/${PN}/
	keepdir /var/lib/${PN}/

	if use X; then
		newicon "${S}"/packages/generic/sea/${PN}mgr.48x48.png ${PN}.png || die
		make_desktop_entry boincmgr "${PN}" "${PN}" "Math;Science" "Path=/var/lib/${PN}"
	fi

	# cleanup cruft
	rm -rf "${ED}"/etc/

	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_preinst() {
	enewgroup ${PN}
	# note this works only for first install so we have to
	# elog user about the need of being in video group
	if use cuda; then
		enewuser ${PN} -1 -1 /var/lib/${PN} "${PN},video"
	else
		enewuser ${PN} -1 -1 /var/lib/${PN} "${PN}"
	fi
}

pkg_postinst() {
	echo
	elog "You are using the source compiled version of ${PN}."
	use X && elog "The graphical manager can be found at /usr/bin/${PN}mgr"
	elog
	elog "You need to attach to a project to do anything useful with ${PN}."
	elog "You can do this by running /etc/init.d/${PN} attach"
	elog "The howto for configuration is located at:"
	elog "http://boinc.berkeley.edu/wiki/Anonymous_platform"
	elog
	# Add warning about the new password for the client, bug 121896.
	if use X; then
		elog "If you need to use the graphical manager the password is in:"
		elog "/var/lib/${PN}/gui_rpc_auth.cfg"
		elog "Where /var/lib/ is default RUNTIMEDIR, that can be changed in:"
		elog "/etc/conf.d/${PN}"
		elog "You should change this password to something more memorable (can be even blank)."
		elog "Remember to launch init script before using manager. Or changing the password."
		elog
	fi
	if use cuda; then
		elog "To be able to use CUDA you should add boinc user to video group."
		elog "Run as root:"
		elog "gpasswd -a boinc video"
	fi
}

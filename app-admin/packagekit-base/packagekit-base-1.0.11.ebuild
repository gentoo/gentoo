# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# PackageKit supports 3.2+, but entropy and portage backends are untested
# Future note: use --enable-python3
PYTHON_COMPAT=( python2_7 )
VALA_USE_DEPEND="vapigen"

inherit bash-completion-r1 multilib nsplugins python-single-r1 systemd vala

MY_PN="PackageKit"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Manage packages in a secure way using a cross-distro and cross-architecture API"
HOMEPAGE="http://www.packagekit.org/"
SRC_URI="https://www.freedesktop.org/software/${MY_PN}/releases/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/18"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE="connman cron command-not-found +introspection networkmanager nsplugin entropy systemd test vala"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	vala? ( introspection )
"

# While not strictly needed, consolekit is the alternative to systemd-login
# to get current session's user.
CDEPEND="
	>=app-shells/bash-completion-2
	dev-db/sqlite:3
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.32.0:2[${PYTHON_USEDEP}]
	>=sys-auth/polkit-0.98
	>=sys-apps/dbus-1.3.0
	${PYTHON_DEPS}
	connman? ( net-misc/connman )
	introspection? ( >=dev-libs/gobject-introspection-0.9.9[${PYTHON_USEDEP}] )
	networkmanager? ( >=net-misc/networkmanager-0.6.4 )
	nsplugin? (
		>=dev-libs/nspr-4.8
		x11-libs/cairo
		>=x11-libs/gtk+-2.14.0:2
		x11-libs/pango
	)
	systemd? ( >=sys-apps/systemd-204 )
"
DEPEND="${CDEPEND}
	dev-libs/libxslt[${PYTHON_USEDEP}]
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
	nsplugin? ( >=net-misc/npapi-sdk-0.27 )
	vala? ( $(vala_depend) )
"
RDEPEND="${CDEPEND}
	>=app-portage/layman-2[${PYTHON_USEDEP}]
	>=sys-apps/portage-2.2[${PYTHON_USEDEP}]
	entropy? ( >=sys-apps/entropy-234[${PYTHON_USEDEP}] )
	!systemd? ( sys-auth/consolekit )
"

S="${WORKDIR}/${MY_P}"

RESTRICT="test"

src_prepare() {
	use vala && vala_src_prepare
}

src_configure() {
	econf \
		--disable-gstreamer-plugin \
		--disable-gtk-doc \
		--disable-gtk-module \
		--disable-schemas-compile \
		--disable-static \
		--enable-bash-completion \
		--enable-man-pages \
		--enable-nls \
		--enable-portage \
		--localstatedir=/var \
		$(use_enable command-not-found) \
		$(use_enable connman) \
		$(use_enable cron) \
		$(use_enable entropy) \
		$(use_enable introspection) \
		$(use_enable networkmanager) \
		$(use_enable nsplugin browser-plugin) \
		$(use_enable systemd) \
		$(use_enable test daemon-tests) \
		$(use_enable vala) \
		$(systemd_with_unitdir)
		#$(use_enable test local)
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --all

	dodoc AUTHORS ChangeLog MAINTAINERS NEWS README

	if use nsplugin; then
		dodir "/usr/$(get_libdir)/${PLUGINS_DIR}"
		mv "${D}/usr/$(get_libdir)/mozilla/plugins"/* \
			"${D}/usr/$(get_libdir)/${PLUGINS_DIR}/" || die
	fi
}

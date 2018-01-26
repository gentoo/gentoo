# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

# PackageKit supports 3.2+, but entropy and portage backends are untested
# Future note: use --enable-python3
PYTHON_COMPAT=( python2_7 )
VALA_USE_DEPEND="vapigen"

inherit autotools bash-completion-r1 multilib python-single-r1 systemd vala xdg

MY_PN="PackageKit"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Manage packages in a secure way using a cross-distro and cross-architecture API"
HOMEPAGE="http://www.packagekit.org/"
SRC_URI="https://www.freedesktop.org/software/${MY_PN}/releases/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/18"
KEYWORDS="~alpha amd64 ~arm ~mips ~ppc ~ppc64 x86"
IUSE="cron command-not-found elogind +introspection entropy systemd test vala"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	?? ( elogind systemd )
	vala? ( introspection )
"

# While not strictly needed, consolekit is the alternative to systemd-login
# or elogind to get current session's user.
COMMON_DEPEND="
	>=app-shells/bash-completion-2
	dev-db/sqlite:3
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.46.0:2[${PYTHON_USEDEP}]
	>=sys-auth/polkit-0.98
	>=sys-apps/dbus-1.3.0
	${PYTHON_DEPS}
	elogind? ( >=sys-auth/elogind-229.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.9:= )
	systemd? ( >=sys-apps/systemd-204 )
"
# vala-common needed for eautoreconf
DEPEND="${COMMON_DEPEND}
	>=dev-cpp/glibmm-2.4
	dev-libs/libxslt[${PYTHON_USEDEP}]
	dev-libs/vala-common
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"
RDEPEND="${COMMON_DEPEND}
	>=app-portage/layman-2[${PYTHON_USEDEP}]
	>=sys-apps/portage-2.2[${PYTHON_USEDEP}]
	entropy? ( >=sys-apps/entropy-234[${PYTHON_USEDEP}] )
	!systemd? ( !elogind? ( sys-auth/consolekit ) )
"

PATCHES=(
	# Fixes QA Notices:
	# - https://github.com/gentoo/gentoo/pull/1760
	# - https://github.com/hughsie/PackageKit/issues/143
	"${FILESDIR}"/${PN}-1.1.1-cache-qafix.patch

	# Adds elogind support:
	# - https://bugs.gentoo.org/show_bug.cgi?id=620948
	"${FILESDIR}"/${P}-elogind-support.patch
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Disable unittests not working with portage backend
	# console: requires terminal input
	sed -e 's:^\(.*/packagekit-glib2/control\)://\1:' \
		-e 's:^\(.*/packagekit-glib2/transaction-list\)://\1:' \
		-e 's:^\(.*/packagekit-glib2/client"\)://\1:' \
		-e 's:^\(.*/packagekit-glib2/package-sack\)://\1:' \
		-e 's:^\(.*/packagekit-glib2/task\)://\1:' \
		-e 's:^\(.*/packagekit-glib2/console\)://\1:' \
		-i lib/packagekit-glib2/pk-test-daemon.c || die
	sed -e 's:^\(.*/packagekit/spawn\)://\1:' \
	    -e 's:^\(.*/packagekit/transaction-db\)://\1:' \
	    -e 's:^\(.*/packagekit/backend\)://\1:' \
		-i src/pk-self-test.c || die

	eapply_user
	use vala && vala_src_prepare
	xdg_src_prepare

	# Needed by elogind patch:
	eautoreconf
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
		$(use_enable cron) \
		$(use_enable elogind) \
		$(use_enable entropy) \
		$(use_enable introspection) \
		$(use_enable systemd) \
		$(use_enable test daemon-tests) \
		$(use_enable test local) \
		$(use_enable vala) \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --all

	dodoc AUTHORS ChangeLog MAINTAINERS NEWS README
}

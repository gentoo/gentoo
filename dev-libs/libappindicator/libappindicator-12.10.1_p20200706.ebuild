# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit autotools multilib-minimal vala

DESCRIPTION="A library to allow applications to export a menu into the Unity Menu bar"
HOMEPAGE="https://launchpad.net/libappindicator"

MY_PV="${PV%_p*}"
PATCH_VERSION="${PV#*_p}"
SRC_URI="mirror://ubuntu/pool/main/liba/${PN}/${PN}_${MY_PV}+20.10.${PATCH_VERSION}.1.orig.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="3"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="+introspection test"

RDEPEND="
	>=dev-libs/dbus-glib-0.98[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.35.4:2[${MULTILIB_USEDEP}]
	>=dev-libs/libdbusmenu-0.6.2[gtk3,${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.2:3[${MULTILIB_USEDEP},introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1:= )
"
DEPEND="${RDEPEND}"
# dev-util/gtk-doc needed for eautoreconf
BDEPEND="
	introspection? ( $(vala_depend) )
	>=dev-util/gtk-doc-1.14
	>=dev-build/gtk-doc-am-1.14
	virtual/pkgconfig
	test? ( dev-util/dbus-test-runner )
"

S="${WORKDIR}"

# FIXME: tests keep trying to access dirs they don't have access, feel free
# to report a bug about how to avoid that
RESTRICT="test"

src_prepare() {
	default
	eautoreconf

	# Disable MONO for now because of https://bugs.gentoo.org/382491
	sed -i -e '/^MONO_REQUIRED_VERSION/s:=.*:=9999:' configure || die
}

multilib_src_configure() {
	if multilib_is_native_abi; then
		local -x VALAC VALA_API_GEN VAPIGEN_VAPIDIR PKG_CONFIG_PATH
		use introspection && vala_src_prepare && export VALA_API_GEN="${VAPIGEN}"
	fi

	ECONF_SOURCE="${S}" \
	econf \
		--disable-static \
		--with-gtk=3 \
		$(multilib_native_use_enable introspection)
}

multilib_src_compile() {
	# Was initially reported in 638782, then fixed, and then fix disappeared.
	# But I facing it every time I (mva) trying to rebuild it on my machine even now (Sep'21)
	emake -j1
}

multilib_src_test() {
	# Prevent tests from trying to write on /dev/fuse
	GVFS_DISABLE_FUSE=1 dbus-run-session emake check
}

multilib_src_install() {
	# Fails in parallel, bug #795444
	emake -j1 DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}

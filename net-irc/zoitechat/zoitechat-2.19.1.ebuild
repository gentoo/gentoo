# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# lua.eclass does not support EAPI 9 yet.
EAPI=8

GENTOO_DEPEND_ON_PERL=no
LUA_COMPAT=( lua5-{1..5} luajit )
PYTHON_COMPAT=( python3_{12..15} )

inherit lua-single perl-module python-single-r1 xdg
# Intentionally called last because ther other inherit clobber exported phases
inherit meson

DESCRIPTION="GTK+ IRC client that's a fork of HexChat"
HOMEPAGE="https://zoitechat.org/"
SRC_URI="https://github.com/ZoiteChat/zoitechat/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 plugin-fishlim? ( MIT )"
SLOT="0"
KEYWORDS="~amd64"

IUSE="dbus debug +gtk libcanberra lua perl perl-legacy plugin-checksum plugin-fishlim plugin-sysinfo python ssl trayicon ${GENTOO_PERL_USESTRING}"
REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	plugin-fishlim? ( ssl )
	python? ( ${PYTHON_REQUIRED_USE} )
"

# app-crypt/libsecret is an automagic dependency
RDEPEND="app-arch/libarchive
	 app-crypt/libsecret
	 >=dev-libs/glib-2.36
	 x11-libs/cairo
	 x11-libs/gdk-pixbuf
	 x11-libs/libX11
	 x11-libs/pango
	 gtk? ( >=x11-libs/gtk+-3.22 )
	 libcanberra? ( >=media-libs/libcanberra-gtk3-0.22 )
	 lua? ( ${LUA_DEPS} )
	 perl? (
		${GENTOO_PERL_DEPSTRING}
		dev-lang/perl:=
	 )
	 plugin-sysinfo? ( sys-apps/pciutils )
	 python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/cffi[${PYTHON_USEDEP}]
			' 'python*')
	 )
	 ssl? ( dev-libs/openssl:= )
	 trayicon? ( dev-libs/libayatana-appindicator )
"

DEPEND="${RDEPEND}"

BDEPEND="app-text/iso-codes
	 dev-util/glib-utils
	 net-misc/publicsuffix-db:=
	 sys-devel/gettext
	 virtual/pkgconfig
	 ${PYTHON_DEPS}"

pkg_setup() {
	use lua && lua-single_pkg_setup
	# Build scripts use Python
	python-single-r1_pkg_setup
}

pkg_preinst() {
	if use gtk ; then
		xdg_pkg_preinst
	fi
}

pkg_postinst() {
	if use gtk ; then
		xdg_pkg_postinst
	else
		elog "You have disabled the gtk USE flag. This means you don't have"
		elog "the GTK-GUI for ZoiteChat but only a text interface called \"zoitechat-text\"."
	fi
}

src_prepare() {
	default
	# Compile process runs Python scripts, so the build shebangs have to be fixed BEFORE src_install
	for PFN in $(find "${S}" -type d -path "${S}/plugins/python" -prune -o -name \*.py -print); do
		python_fix_shebang "${PFN}"
	done
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk gtk-frontend)
		$(meson_use !gtk text-frontend)
		$(meson_use perl-legacy with-perl-legacy-api)
		$(meson_use plugin-checksum with-checksum)
		$(meson_use plugin-fishlim with-fishlim)
		$(meson_use plugin-sysinfo with-sysinfo)
		$(meson_feature dbus)
		$(meson_feature libcanberra)
		$(meson_feature ssl tls)
		$(meson_feature trayicon appindicator)
		-Dwith-lua="$(usex lua "${ELUA}" false)"
		-Dwith-perl="$(usex perl "${EPREFIX}"/usr/bin/perl false)"
		-Dwith-python="$(usex python "${EPYTHON/.*}" false)"
		-Dplugin=true
		# Flakpak options
		-Ddbus-service-use-appid=false
		-Dinstall-appdata=false
		# For use by distros who package the plugins separately
		-Dinstall-plugin-metainfo=false
		# exec and upd are Windows only
		-Dwith-exec=false
		-Dwith-upd=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use python ; then
		for PFN in $(find "${ED}" -type f -path "${ED}/plugins/python/\*.py"); do
			python_fix_shebang "${PFN}"
		done
	fi
}

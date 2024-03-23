# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..5} luajit )
PYTHON_COMPAT=( python3_{10..12} )

inherit lua-single meson mono-env python-single-r1 xdg

DESCRIPTION="Graphical IRC client based on XChat"
HOMEPAGE="https://hexchat.github.io/"

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	# We need to empty SRC_URI or else mono-env breaks the live ebuild
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux"
fi

LICENSE="GPL-2 plugin-fishlim? ( MIT )"
SLOT="0"
IUSE="dbus debug +gtk libcanberra lua perl plugin-checksum plugin-fishlim plugin-sysinfo python ssl theme-manager"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	plugin-fishlim? ( ssl )
	python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/glib:2
	dbus? ( dev-libs/dbus-glib )
	gtk? (
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
		x11-libs/libX11
		x11-libs/pango
	)
	libcanberra? ( media-libs/libcanberra )
	lua? ( ${LUA_DEPS} )
	perl? ( dev-lang/perl:= )
	plugin-sysinfo? ( sys-apps/pciutils )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/cffi[${PYTHON_USEDEP}]
		' 'python*')
	)
	ssl? ( dev-libs/openssl:0= )
	theme-manager? (
		|| (
			(
				dev-lang/mono[minimal]
				dev-dotnet/libgdiplus
			)
			dev-lang/mono[-minimal]
		)
	)"

DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	app-text/iso-codes
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_setup() {
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup
	if use theme-manager ; then
		mono-env_pkg_setup
		export XDG_CACHE_HOME="${T}/.cache"
	fi
}

src_configure() {
	local emesonargs=(
		-Ddbus-service-use-appid=false
		-Dinstall-appdata=false
		-Dplugin=true
		$(meson_feature dbus)
		$(meson_feature libcanberra)
		$(meson_feature ssl tls)
		$(meson_use gtk gtk-frontend)
		$(meson_use !gtk text-frontend)
		$(meson_use theme-manager)

		$(meson_use plugin-checksum with-checksum)
		$(meson_use plugin-fishlim with-fishlim)
		-Dwith-lua="$(usex lua "${ELUA}" false)"
		-Dwith-perl="$(usex perl "${EPREFIX}"/usr/bin/perl false)"
		-Dwith-python="$(usex python "${EPYTHON/.*}" false)"
		$(meson_use plugin-sysinfo with-sysinfo)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	dodoc readme.md
	find "${ED}" -type f -name '*.la' -delete || die
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
		elog "the GTK-GUI for HexChat but only a text interface called \"hexchat-text\"."
	fi

	if use theme-manager ; then
		elog "Themes are available at:"
		elog "  https://hexchat.github.io/themes.html"
	fi

	elog
	elog "optional dependencies:"
	elog "  media-sound/sox (sound playback if you don't have libcanberra"
	elog "    enabled)"
	elog "  x11-themes/sound-theme-freedesktop (default BEEP sound,"
	elog "    needs libcanberra enabled)"
}

pkg_postrm() {
	if use gtk ; then
		xdg_pkg_postrm
	fi
}

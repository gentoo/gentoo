# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="sqlite"
inherit gnome2-utils meson python-single-r1 xdg

DESCRIPTION="Modern music player for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Lollypop"
# Tarballs on adishatz.org have files from Git submodule 'subprojects/po'
SRC_URI="https://adishatz.org/${PN}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64"

IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

# Dependencies being checked by Meson
DEPEND="
	dev-libs/glib:2
	dev-libs/gobject-introspection
	net-libs/libsoup:3.0[introspection]
	x11-libs/gtk+:3[introspection]
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	')
"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	test? (
		dev-libs/appstream-glib
		dev-util/desktop-file-utils
	)
"

RDEPEND="
	${DEPEND}
	app-crypt/libsecret[introspection]
	dev-libs/totem-pl-parser[introspection]
	gui-libs/libhandy:1[introspection]
	media-plugins/gst-plugins-pulse
	$(python_gen_cond_dep '
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/gst-python[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
	')
"

src_install() {
	meson_src_install
	python_optimize
	python_fix_shebang "${ED}/usr/bin"
	python_fix_shebang "${ED}/usr/libexec/lollypop-sp"
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Remember to install the necessary gst-plugins packages for your audio files."
		elog "You can also use the gst-plugins-meta package and its USE flags."
	fi

	local log_yt_dlp ver
	for ver in ${REPLACING_VERSIONS}; do
		ver_test "${ver}" -lt "1.4.36" && log_yt_dlp=1
	done
	[[ ${log_yt_dlp} ]] &&
		elog "Since version 1.4.36, Lollypop relies on yt-dlp instead of youtube-dl."
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

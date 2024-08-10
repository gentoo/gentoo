# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo gnome2-utils meson xdg-utils

DESCRIPTION="Photo gallery for Linux"
HOMEPAGE="https://github.com/blissd/fotema"
SRC_URI="
	https://github.com/blissd/fotema/releases/download/v${PV}/${P}.tar.xz
"

# see LICENSES/
LICENSE="
	CC-BY-2.0 CC-BY-4.0 CC-BY-NC-SA-4.0 CC-BY-SA-4.0 CC0-1.0
	FDL-1.3+ GPL-3+ MIT
"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/glib-2.66:2
	>=gui-libs/gtk-4.0.0:4
"
# indirect deps via crates
DEPEND+="
	dev-libs/openssl:=
	gui-libs/libadwaita
	media-libs/fontconfig
	media-libs/graphene
	media-libs/lcms:2
	media-libs/libshumate:=
	media-libs/opencv:=[contribdnn]
	media-video/ffmpeg:=
	sci-libs/onnx
	sys-libs/libseccomp
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-libs/glib:2
"

ECARGO_VENDOR=${S}/vendor

QA_FLAGS_IGNORED="/usr/bin/fotema"

src_prepare() {
	default
	sed -i -e "/i18ndir =/s:'i18n':'share' / 'fotema' / &:" meson.build || die
}

src_configure() {
	cat >> "${ECARGO_HOME}/config.toml" <<-EOF || die

		[source."git+https://github.com/blissd/rust-faces.git?branch=patch"]
		git = "https://github.com/blissd/rust-faces.git"
		branch = "patch"
		replace-with = "gentoo"
	EOF

	local emesonargs=(
		-Dprofile=$(usex debug development default)
	)

	meson_src_configure
	ln -s "${CARGO_HOME}" "${BUILD_DIR}/cargo-home" || die

	export ORT_STRATEGY=system
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

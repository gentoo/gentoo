# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Tool to build flatpaks from source"
HOMEPAGE="https://flatpak.org/"
SRC_URI="https://github.com/flatpak/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="doc +yaml"

# dev-util/flatpak and dev-libs/appstream are runtime dependencies of flatpak-builder
# their binaries are actively being used by flatpak-builder as is
# qa-vdb returns false-positive warnings
RDEPEND="
	>=dev-util/ostree-2019.5:=
	>=dev-libs/appstream-0.15.0:=[compose]
	>=dev-libs/elfutils-0.8.12:=
	>=dev-libs/glib-2.66:2=
	>=dev-libs/libxml2-2.4:=
	dev-libs/json-glib:=
	net-misc/curl:=
	>=sys-apps/flatpak-0.99.1
	yaml? ( dev-libs/libyaml:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/xmlto
		dev-libs/libxslt
	)
"

PATCHES=("${FILESDIR}/flatpak-builder-1.2.2-musl.patch")

src_configure() {
	local emesonargs=(
		$(meson_feature doc docs)
		$(meson_feature yaml)
	)
	meson_src_configure
}

src_install() {
	# conventional HTML docs location /usr/share/doc/${PN}/html
	local HTML_DOCS=()
	use doc && HTML_DOCS=( "${BUILD_DIR}"/doc/flatpak-builder-docs.html "${S}"/doc/docbook.css )

	meson_src_install

	if use doc; then
		rm -r "${ED}"/usr/share/doc/${PN} || die
	fi
}

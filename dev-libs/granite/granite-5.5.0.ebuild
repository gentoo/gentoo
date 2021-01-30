# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION=0.40
BUILD_DIR="${WORKDIR}/${P}-build"

inherit meson vala xdg

DESCRIPTION="Elementary OS library that extends GTK+"
HOMEPAGE="https://github.com/elementary/granite"
SRC_URI="https://github.com/elementary/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

BDEPEND="
	$(vala_depend)
	virtual/pkgconfig
	doc? (
		>=dev-lang/vala-0.40.20[valadoc]
		dev-util/gtk-doc
	)
"
DEPEND="
	>=dev-libs/glib-2.50:2
	>=x11-libs/gtk+-3.22:3[introspection]
	dev-libs/libgee:0.8[introspection]
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	vala_src_prepare

	# Fix docs
	sed -i "s/find_program('valadoc')/find_program('valadoc-$(vala_best_api_version)')/g" doc/meson.build \
		|| die "Failed to replace valadoc"
	find lib/Widgets -type f -name "*.vala" -exec sed -ie "s@{{../doc@{{${BUILD_DIR}/doc@g" {} \; \
		|| die "Failed to fix docs"
}

src_configure() {
	local emesonargs=(
		$(meson_use doc documentation)
	)
	meson_src_configure

	if use doc; then
		cp -r ./doc/images "${BUILD_DIR}/doc/" || die "Failed to copy doc images"
	fi
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}/doc/granite/html/." )
	meson_src_install
}

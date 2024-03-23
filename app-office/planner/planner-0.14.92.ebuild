# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Project manager for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Planner https://gitlab.gnome.org/World/planner"
if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://gitlab.gnome.org/World/planner.git"
	inherit git-r3
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm64"
fi

SLOT="0"
LICENSE="GPL-2+"
IUSE="examples libgda"

RDEPEND="
	>=dev-libs/glib-2.56:2
	>=x11-libs/gtk+-3.22:3
	>=dev-libs/libxml2-2.6.27:2
	>=dev-libs/libxslt-1.1.23
	libgda? ( >=gnome-extra/libgda-1.0:5 )
"
DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
"

src_configure() {
	local emesonargs=(
		$(meson_feature libgda database-gda)
		-Deds=disabled # Doesn't provide much value, not very tested
		$(meson_use examples)
		-Dgtk_doc=false # Only for a private library
		-Dsimple-priority-scheduling=false # experimental
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use examples; then
		mv "${ED}"/usr/share/doc/planner "${ED}"/usr/share/doc/${PF} || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

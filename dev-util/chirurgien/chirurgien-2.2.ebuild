# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson xdg

DESCRIPTION="Chirurgien helps to understand and manipulate file formats"
HOMEPAGE="https://github.com/leonardschardijn/Chirurgien/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/leonardschardijn/${PN^}.git"
else
	SRC_URI="https://github.com/leonardschardijn/${PN^}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${P^}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	gui-libs/gtk:4
	dev-libs/glib:2
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
"

PATCHES=( "${FILESDIR}/${PN}-2.1-dont-validate-appstream.patch" )

src_prepare() {
	# Do not use the provided postinstall script.
	sed -i "/^meson.add_install_script/d" meson.build || die

	default
}

src_install() {
	meson_src_install

	mv "${ED}"/usr/share/appdata "${ED}"/usr/share/metainfo || die
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils

# Workaround until https://bugzilla.gnome.org/show_bug.cgi?id=663725 is fixed
DESCRIPTION="Show tooltip with full name and description"
HOMEPAGE="https://github.com/RaphaelRochet/applications-overview-tooltip"
SRC_URI="https://github.com/RaphaelRochet/applications-overview-tooltip/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# https://github.com/RaphaelRochet/applications-overview-tooltip/issues/7
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.38
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}/${P/gnome-shell-extension-}"

src_install() {
	einstalldocs
	insinto /usr/share/glib-2.0/schemas
	doins schemas/*.xml
	rm -rf README.md schemas || die
	insinto /usr/share/gnome-shell/extensions/applications-overview-tooltip@RaphaelRochet
	doins -r *
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

pkg_postrm() {
	gnome2_schemas_update
}

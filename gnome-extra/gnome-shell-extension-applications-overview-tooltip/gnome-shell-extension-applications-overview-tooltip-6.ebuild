# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Workaround until https://bugzilla.gnome.org/show_bug.cgi?id=663725 is fixed
DESCRIPTION="Show tooltip with full name and description"
HOMEPAGE="https://github.com/RaphaelRochet/applications-overview-tooltip"
SRC_URI="https://github.com/RaphaelRochet/applications-overview-tooltip/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# https://github.com/RaphaelRochet/applications-overview-tooltip/issues/7
LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# glib for glib-compile-schemas at build time, needed at runtime anyways
COMMON_DEPEND="
	dev-libs/glib:2
"
RDEPEND="${COMMON_DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.20
"
DEPEND="${COMMON_DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P/gnome-shell-extension-}"

src_install() {
	einstalldocs
	rm -f README.md || die
	insinto /usr/share/gnome-shell/extensions/applications-overview-tooltip@RaphaelRochet
	doins -r *
	glib-compile-schemas "${ED}"/usr/share/gnome-shell/extensions/applications-overview-tooltip@RaphaelRochet/schemas || die
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

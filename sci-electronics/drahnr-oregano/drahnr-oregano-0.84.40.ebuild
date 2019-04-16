# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6,7} )
PYTHON_REQ_USE='threads(+)'

inherit gnome2-utils python-any-r1 waf-utils xdg-utils

DESCRIPTION="Application for the schematic capturing and simulation of electrical circuits"
HOMEPAGE="https://github.com/drahnr/oregano"
SRC_URI="https://github.com/drahnr/oregano/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

S="${WORKDIR}/oregano-${PV}"

COMMON_DEP="dev-libs/glib:2
	dev-libs/libxml2:2
	x11-libs/goocanvas:2.0
	x11-libs/gtk+:3
	x11-libs/gtksourceview:3.0"

DEPEND="${COMMON_DEP}
	${PYTHON_DEPS}
	dev-util/glib-utils
	virtual/pkgconfig"

RDEPEND="${COMMON_DEP}
	|| ( gnome-base/dconf gnome-base/gconf )
	sci-electronics/electronics-menu"

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		python-any-r1_pkg_setup
	fi
}

src_configure() { waf-utils_src_configure; }

src_install() {
	waf-utils_src_install --no-xdg --no-install-gschema
	docompress -x /usr/share/doc/${PF}/{dev-docs,sequence}
	dodoc -r docs/{dev-docs,sequence,user-docs}
	insinto /usr/share/glib-2.0/schemas
	doins data/settings/io.ahoi.oregano.gschema.xml
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

	elog "Note: You'll need to emerge your prefered simulation backend"
	elog "such as sci-electronics/ngspice (preferred) or sci-electronics/gnucap"
	elog "for simulation to work."
	elog "As an alternative generate a netlist and use sci-electronics/spice"
	elog "from the command line for simulation."
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

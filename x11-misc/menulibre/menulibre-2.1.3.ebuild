# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="xml"
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1 eutils gnome2-utils versionator

DESCRIPTION="Advanced freedesktop.org compliant menu editor"
HOMEPAGE="http://www.smdavis.us/projects/menulibre/"
SRC_URI="https://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-libs/gobject-introspection
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	gnome-base/gnome-menus[introspection]
	x11-libs/gdk-pixbuf[X,introspection]
	x11-libs/gtk+:3[X,introspection]
	x11-libs/gtksourceview:3.0[introspection]
	x11-themes/hicolor-icon-theme
"

python_prepare_all() {
	# too many categories
	sed -i \
		-e 's/X-GNOME-Settings-Panel;X-GNOME-PersonalSettings;DesktopSettings;X-XFCE;//' \
		menulibre.desktop.in || die

	local i
	# fix incorrect behavior when LINGUAS is set to an empty string
	# https://bugs.launchpad.net/python-distutils-extra/+bug/1133594
	if [[ -n "${LINGUAS+x}" ]] ; then # if LINGUAS is set
		for i in $(cd "${S}"/po ; for p in *.po ; do echo ${p%.po} ; done) ; do # for every supported language
			if ! has ${i} ${LINGUAS} ; then # if language is disabled
				rm po/${i}.po || die
			fi
		done
	fi

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

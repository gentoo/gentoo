# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="xml"
DISTUTILS_IN_SOURCE_BUILD=1
inherit desktop distutils-r1 xdg-utils

DESCRIPTION="Advanced freedesktop.org compliant menu editor"
HOMEPAGE="https://bluesabre.org/projects/menulibre/"
SRC_URI="https://launchpad.net/${PN}/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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
		-e '/^OnlyShowIn/d' \
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
	rm -r "${ED}"/usr/share/doc/${PN} || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}

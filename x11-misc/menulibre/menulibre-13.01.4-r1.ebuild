# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/menulibre/menulibre-13.01.4-r1.ebuild,v 1.2 2014/04/26 08:30:46 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"
DISTUTILS_IN_SOURCE_BUILD=1
inherit eutils gnome2-utils distutils-r1

DESCRIPTION="An advanced menu editor that provides modern features in a clean, easy-to-use interface"
HOMEPAGE="http://www.smdavis.us/projects/menulibre/"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/python-distutils-extra[${PYTHON_USEDEP}]"
RDEPEND="dev-libs/gobject-introspection
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gdk-pixbuf[X,introspection]
	x11-libs/gtk+:3[X,introspection]
	x11-themes/hicolor-icon-theme"

PATCHES=( "${FILESDIR}"/${P}-GError-import.patch )

S=${WORKDIR}/${PN}

python_prepare_all() {
	# too many categories
	sed -i \
		-e 's/X-GNOME-Settings-Panel;X-GNOME-PersonalSettings;DesktopSettings;X-XFCE;//' \
		menulibre.desktop.in || die 'sed on menulibre.desktop.in failed'

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
	newicon -s 32 help/C/figures/icon.png menu-editor.png
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	elog "optional dependencies:"
	elog "  gnome-extra/yelp (view help contents)"
}

pkg_postrm() {
	gnome2_icon_cache_update
}

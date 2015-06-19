# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/terminator/terminator-0.97-r1.ebuild,v 1.2 2015/04/08 17:26:26 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_NO_PARALLEL_BUILD=true

inherit gnome2 distutils-r1

DESCRIPTION="Multiple GNOME terminals in one window"
HOMEPAGE="http://www.tenshu.net/p/terminator.html"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus gnome +libnotify"

RDEPEND="
	dev-libs/keybinder:0[python]
	x11-libs/vte:0[python]
	dbus? ( sys-apps/dbus )
	gnome? (
		dev-python/gconf-python
		dev-python/libgnome-python
		dev-python/pygobject:2[${PYTHON_USEDEP}]
		dev-python/pygtk:2[${PYTHON_USEDEP}]
		)
	libnotify? ( dev-python/notify-python[${PYTHON_USEDEP}] )"
DEPEND="dev-util/intltool"

S="${WORKDIR}"/trunk

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/0.90-without-icon-cache.patch
		"${FILESDIR}"/0.94-session.patch
		"${FILESDIR}"/${P}-brightness.patch
	)

	local i p
	if [[ -n "${LINGUAS+x}" ]] ; then
		pushd "${S}"/po > /dev/null
		strip-linguas -i .
		for i in *.po; do
			if ! has ${i%.po} ${LINGUAS} ; then
				rm ${i} || die
			fi
		done
		popd > /dev/null
	fi

	distutils-r1_python_prepare_all
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}

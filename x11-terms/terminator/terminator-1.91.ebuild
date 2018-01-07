# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit gnome2 distutils-r1 virtualx

DESCRIPTION="Multiple GNOME terminals in one window"
HOMEPAGE="http://www.tenshu.net/p/terminator.html"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus doc gnome +libnotify"

RDEPEND="
	dev-libs/keybinder:0[python]
	dev-python/psutil
	>=x11-libs/vte-0.46.2
	dbus? ( sys-apps/dbus )
	gnome? (
		dev-python/gconf-python
		dev-python/libgnome-python
		dev-python/pygobject:2[${PYTHON_USEDEP}]
		dev-python/pygtk:2[${PYTHON_USEDEP}]
		)
	libnotify? ( dev-python/notify-python[${PYTHON_USEDEP}] )
"
DEPEND="
	dev-util/intltool
"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/0.90-without-icon-cache.patch
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

	sed \
		-e "/'share', 'doc'/s:${PN}:${PF}:g" \
		-i setup.py terminatorlib/util.py || die

	use doc || \
		sed \
			-e '/install_documentation/s:True:False:g' \
			-i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	VIRTUALX_COMMAND="esetup.py"
	virtualmake test
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}

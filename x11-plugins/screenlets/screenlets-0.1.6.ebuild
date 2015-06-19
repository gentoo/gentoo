# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/screenlets/screenlets-0.1.6.ebuild,v 1.6 2015/04/08 17:26:17 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=yes

inherit distutils-r1 eutils

DESCRIPTION="Screenlets are small owner-drawn applications"
HOMEPAGE="http://www.screenlets.org https://launchpad.net/screenlets"
SRC_URI="http://code.launchpad.net/screenlets/trunk/${PV}/+download/screenlets-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+svg"

RDEPEND="
	dev-python/beautifulsoup:python-2
	dev-python/dbus-python
	dev-python/gconf-python
	dev-python/gnome-keyring-python
	dev-python/libwnck-python
	dev-python/pyxdg
	svg? ( dev-python/librsvg-python )
	x11-libs/libnotify
	x11-misc/xdg-utils
"

src_prepare() {
	# this is tricky because screenlets translations do not always have -manager
	# translations and vice versa, which is also why we do not die() on rm fail
	strip-linguas -u ${PN}/ ${PN}-manager/
	local lingua pofile
	for pofile in ${PN}/*.po ${PN}-manager/*.po; do
		lingua=${pofile/$PN*\/}
		lingua=${lingua/.po}

		if ! has ${lingua} ${LINGUAS}; then
			rm -f ${PN}/${lingua}.po
			rm -f ${PN}-manager/${lingua}.po
		fi
	done

	distutils-r1_src_prepare
	python_fix_shebang src/
	sed -i $(find src/ -type f) -e 's|exec python|&2|g;s|python -u|python2 -u|g' || die
	sed -i desktop-menu/screenlets-{daemon,manager}.desktop -e 's|> .*||g' || die
}

src_install() {
	distutils-r1_src_install

	insinto /usr/share/icons
	doins desktop-menu/screenlets.svg

	# Insert .desktop files
	domenu desktop-menu/*.desktop
}

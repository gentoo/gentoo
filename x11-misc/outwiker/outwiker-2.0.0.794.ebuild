# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit eutils python-r1

DESCRIPTION="The tree notes organizer"
HOMEPAGE="http://jenyay.net/Outwiker/English"
SRC_URI="https://github.com/Jenyay/${PN}/archive/unstable_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="" # Keywords are dropped, cause this version cause a LOT of crashes

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/wxpython:3.0[${PYTHON_USEDEP}]
	x11-libs/wxGTK:3.0[webkit]
	x11-misc/xdg-utils
	x11-themes/hicolor-icon-theme
"

S="${WORKDIR}/${PN}-unstable_${PV}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	# fix desktop file
	sed -i -e 's/Application;//' need_for_build/debian_debsource/outwiker.desktop || die 'sed on outwiker.desktop failed'

	eapply_user
}

src_compile() { :; }

src_install() {
	# Do not install tests
	rm -r src/test*

	insinto "/usr/share/${PN}"
	doins -r src/*
	dobin "need_for_build/debian_debsource/${PN}"

	domenu "need_for_build/debian_debsource/${PN}.desktop"
	dodoc README README.md

	# Install mans
	doman need_for_build/debian_debsource/man/man1/${PN}.1
	insinto /usr/share/man/ru/man1
	doins need_for_build/debian_debsource/man/ru/man1/${PN}.1

	# Install icons
	doicon "images/${PN}.xpm"
	newicon -s scalable "images/${PN}.svg" "${PN}.svg"
	for i in 16 22 24 32 48 64 128 256; do
		newicon -s $i "images/${PN}_$i.png" "${PN}.png"
	done
}

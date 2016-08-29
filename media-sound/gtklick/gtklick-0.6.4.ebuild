# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="A simple metronome with an easy-to-use GTK interface"
HOMEPAGE="http://das.nasophon.de/gtklick/"
SRC_URI="http://das.nasophon.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="dev-python/pygtk[${PYTHON_USEDEP}]
	media-libs/pyliblo[${PYTHON_USEDEP}]
	media-sound/klick[osc]
	${PYTHON_DEPS}"

DEPEND="${RDEPEND}"

src_install() {
	distutils-r1_src_install

	# Replace the broken default runner script with a working one.
	sed \
		-e "s|[@]sharedir[@]|${EPREFIX}/usr/share/${PN}|g" \
		-e "s|[@]localedir[@]|${EPREFIX}/usr/share/locale|g" \
		"${FILESDIR}"/${PN} > "${T}"/${PN} || die
	python_replicate_script "${T}"/${PN}
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit eutils python-r1

DESCRIPTION="GUI for lossless cropping of jpeg images"
HOMEPAGE="http://emergent.unpythonic.net/01248401946"
SRC_URI="https://github.com/jepler/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${PYTHON_DEPS}
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
"

src_prepare() {
	sed -i  -e '/Encoding/d' \
		-e '/Version/d' \
		-e '/MimeType/s/$/&;/' \
		-e '/Categories/s/Application;//' \
		cropgui.desktop || die 'sed on cropgui.desktop failed'
	# bug 471530
	eapply "${FILESDIR}/${P}-PIL.patch"

	eapply_user
}

install_cropgui_wrapper() {
	python_domodule cropgtk.py cropgui_common.py filechooser.py cropgui.glade
	make_wrapper "${PN}.tmp" "${PYTHON} $(python_get_sitedir)/${PN}/cropgtk.py"
	python_newexe "${ED%/}/usr/bin/${PN}.tmp" "${PN}"
	rm "${ED%/}/usr/bin/${PN}.tmp" || die
}

src_install() {
	local python_moduleroot="${PN}"
	python_foreach_impl install_cropgui_wrapper

	domenu "${PN}.desktop"
	doicon "${PN}.png"
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://github.com/jepler/cropgui.git"
PYTHON_COMPAT=( python2_7 )
inherit eutils git-r3 python-r1

DESCRIPTION="GUI for lossless cropping of jpeg images"
HOMEPAGE="http://emergent.unpythonic.net/01248401946"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

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

	eapply_user
}

install_cropgui_wrapper() {
	python_domodule cropgtk.py cropgui_common.py filechooser.py cropgui.glade
	make_wrapper "${PN}.tmp" "${PYTHON} $(python_get_sitedir)/${PN}/cropgtk.py"
	python_newexe "${ED%/}/usr/bin/${PN}.tmp" "${PN}"
	rm "${ED%/}/usr/bin/${PN}.tmp" || die
}

src_install() {
	python_moduleinto "${PN}"
	python_foreach_impl install_cropgui_wrapper

	domenu "${PN}.desktop"
	doicon "${PN}.png"
}

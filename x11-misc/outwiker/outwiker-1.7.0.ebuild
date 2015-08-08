# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_DEPEND="2:2.7"
inherit python

DESCRIPTION="The tree notes organizer"
HOMEPAGE="http://jenyay.net/Outwiker/English"
SRC_URI="http://jenyay.net/uploads/Soft/Outwiker/${P}-src-full.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pywebkitgtk
	dev-python/wxpython"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	# fix desktop file
	sed -i -e 's/Application;//' outwiker.desktop || die 'sed on outwiker.desktop failed'
}

src_compile() { :; }

pkg_postinst() {
	python_mod_optimize "${ED}/usr/share/${PN}"
}

pkg_postrm() {
	python_mod_cleanup "${ED}/usr/share/${PN}"
}

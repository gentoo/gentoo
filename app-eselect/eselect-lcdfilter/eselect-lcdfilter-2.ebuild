# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit vcs-snapshot readme.gentoo

DESCRIPTION="Eselect module to choose Freetype infinality-enhanced LCD filtering settings"
HOMEPAGE="https://github.com/yngwin/eselect-lcdfilter"
SRC_URI="${HOMEPAGE}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-admin/eselect"
PDEPEND="media-libs/freetype[infinality]"

src_install() {
	DOC_CONTENTS="Use eselect lcdfilter to select an lcdfiltering font style.
	You can customize ${EPREFIX}/usr/share/${PN}/env.d/custom with your own settings.
	See ${EPREFIX}/usr/share/doc/${PF}/infinality-settings.sh for an explanation and
	examples of the variables. This module is supposed to be used in pair with
	eselect infinality."

	dodoc README.rst infinality-settings.sh
	readme.gentoo_create_doc

	insinto "/usr/share/eselect/modules"
	doins lcdfilter.eselect

	insinto "/usr/share/${PN}"
	doins -r env.d
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit vcs-snapshot

DESCRIPTION="Eselect module to choose Freetype infinality-enhanced LCD filtering settings"
HOMEPAGE="https://github.com/yngwin/eselect-lcdfilter"
SRC_URI="${HOMEPAGE}/tarball/v1 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="app-admin/eselect"
PDEPEND="media-libs/freetype[infinality]"

src_install() {
	dodoc README.rst infinality-settings.sh

	insinto "/usr/share/eselect/modules"
	doins lcdfilter.eselect

	insinto "/usr/share/${PN}"
	doins -r env.d
}

pkg_postinst() {
	elog "Use eselect lcdfilter to select an lcdfiltering font style."
	elog "You can customize /usr/share/${PN}/env.d/custom"
	elog "with your own settings. See /usr/share/doc/${PF}/infinality-settings.sh"
	elog "for an explanation and examples of the variables."
	elog "This module is supposed to be used in pair with eselect infinality."
}

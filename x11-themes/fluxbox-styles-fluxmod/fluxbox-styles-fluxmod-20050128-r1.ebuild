# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="A collection of FluxBox themes from FluxMod"
HOMEPAGE="http://tenr.de/styles/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND=">=sys-apps/sed-4"

src_prepare() {
	# comment out every rootcommand
	find . -name '*.cfg' -exec \
		sed -i "{}" -e 's-^\(rootcommand\)-!!! \1-i' \;
	# weird tarball...
	find . -exec chmod a+r '{}' \;
}

src_install() {
	insinto /usr/share/fluxbox/fluxmod/styles
	doins -r * || die
	insinto /usr/share/fluxbox/menu.d/styles
	doins "${FILESDIR}"/styles-menu-fluxmod || die
}

pkg_postinst() {
	einfo
	einfo "These styles are installed into /usr/share/fluxbox/fluxmod/. The"
	einfo "best way to use these styles is to ensure that you are running"
	einfo "fluxbox 0.9.10-r3 or later, and then to place the following in"
	einfo "your menu file:"
	einfo
	einfo "    [submenu] (Styles) {Select a Style}"
	einfo "        [include] (/usr/share/fluxbox/menu.d/styles/)"
	einfo "    [end]"
	einfo
	einfo "If you use fluxbox-generate_menu or the default global fluxbox"
	einfo "menu file, this will already be present."
	einfo
	einfo "Note that some of these styles use the PNG image format. For"
	einfo "these to work, fluxbox must be built with USE=\"imlib\" and"
	einfo "imlib2 must be built with USE=\"png\"."
	einfo
}

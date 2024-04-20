# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A collection of FluxBox themes from FluxMod"
HOMEPAGE="https://tenr.de/styles/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86"

src_prepare() {
	# comment out every rootcommand
	find . -name '*.cfg' -exec \
		sed -i "{}" -e 's-^\(rootcommand\)-!!! \1-i' \; || die "sed failed"
	# weird tarball...
	find . -exec chmod a+r '{}' \; || die "chmod on tarball failed"

	eapply_user
}

src_install() {
	insinto /usr/share/fluxbox/fluxmod/styles
	doins -r *
	insinto /usr/share/fluxbox/menu.d/styles
	doins "${FILESDIR}"/styles-menu-fluxmod
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

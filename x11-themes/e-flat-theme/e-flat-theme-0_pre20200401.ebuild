# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A modern, flat theme for Enlightenment WM"
HOMEPAGE="https://www.enlightenment.org/ https://phab.enlightenment.org/T6726"
SRC_URI="https://dev.gentoo.org/~juippis/distfiles/${P}.edj"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"

RDEPEND="x11-wm/enlightenment"

S="${WORKDIR}"

src_prepare() {
	default

	# doins doesn't allow installing straight from DISTDIR.
	cp "${DISTDIR}"/${P}.edj . || die "Failed to prepare theme file."
}

src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto /usr/share/elementary/themes/
	newins ${P}.edj flat-0.edj
}

pkg_postinst() {
	elog "You'll find e-flat-theme under System themes in theme selector."

	if [[ -n ${REPLACING_VERSIONS} ]]; then
		ewarn ""
		ewarn "You're updating flat-0 theme. Please reload Enlightenment"
		ewarn "through Menu -> Enlightenment -> Restart, or by issuing"
		ewarn "  enlightenment -restart"
		ewarn ""
	fi
}

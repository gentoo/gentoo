# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A modern, flat theme for Enlightenment WM"
HOMEPAGE="https://www.enlightenment.org/ https://phab.enlightenment.org/T6726"
SRC_URI="https://dev.gentoo.org/~juippis/distfiles/${P}.edj"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
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
	doins ${P}.edj
}

pkg_postinst() {
	elog "You'll find e-flat-theme under System themes in theme selector."
}

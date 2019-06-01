# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/xcursors/cursors}"
DESCRIPTION="An x-cursor theme inspired by macOS and based on KDE Breeze"
HOMEPAGE="https://github.com/keeferrourke/capitaine-cursors"
SRC_URI="https://github.com/keeferrourke/${MY_PN}/archive/r${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="+standard white"
REQUIRED_USE="|| ( standard white )"

BDEPEND="
	media-gfx/imagemagick
	x11-apps/xcursorgen
"

S="${WORKDIR}/${MY_PN}-r${PV}"

DOCS=(
	COPYING
	README.md
	preview.png
	product.svg
)

PATCHES=(
	"${FILESDIR}/${P}-convert-fix.patch"
	"${FILESDIR}/${P}-custom-build-fix.patch"
)

src_prepare() {
	default

	rm -r dist dist-white || die "the cleaning has failed"
}

src_compile() {
	if use standard; then
		./build.sh -c standard || die "the building has failed for the standard theme"
	fi

	if use white; then
		./build.sh -c white || die "the building has failed for the white theme"
	fi
}

src_install() {
	einstalldocs

	if use standard; then
		insinto "/usr/share/cursors/xorg-x11/${MY_PN}"
		doins -r dist/*
	fi

	if use white; then
		insinto "/usr/share/cursors/xorg-x11/${MY_PN}-white"
		doins -r dist-white/*
	fi
}

pkg_postinst() {
	einfo "To use this set of cursors, edit or create the file ~/.Xdefaults"
	einfo "and add the following line (for example):"
	einfo "Xcursor.theme: Capitaine Cursors"
	einfo ""
	einfo "You can change the size by adding a line like:"
	einfo "Xcursor.size: 48"
	einfo ""
	einfo "Also, to globally use this set of mouse cursors edit the file:"
	einfo "   /usr/local/share/cursors/xorg-x11/default/index.theme"
	einfo "and change the line:"
	einfo "    Inherits=[current setting]"
	einfo "to (for example)"
	einfo "    Inherits=Capitaine Cursors"
	einfo ""
	einfo "Note this will be overruled by a user's ~/.Xdefaults file."
	einfo ""
	ewarn "If you experience flickering, try setting the following line in"
	ewarn ""
	ewarn "the Device section of your xorg.conf file:"
	ewarn "    Option  \"HWCursor\"  \"false\""
	einfo ""
	einfo "The three sets installed are ${MY_PN} and ${MY_PN}-white."
}

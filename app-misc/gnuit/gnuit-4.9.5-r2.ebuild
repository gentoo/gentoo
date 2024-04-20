# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="GNU Interactive Tools - increase speed and efficiency of most daily tasks"
HOMEPAGE="https://www.gnu.org/software/gnuit/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 FDL-1.3"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${PN}-4.9.5-respect-AR.patch
)

src_prepare() {
	default

	# for AR patch
	eautoreconf
}

src_configure() {
	tc-export AR

	# The transition option controls whether a "git" wrapper is installed, it is
	# disabled explicitly so we don't need to block on dev-vcs/git.
	econf --disable-transition
}

src_install() {
	default

	#emake DESTDIR="${D}" htmldir="/usr/share/doc/${PF}/html" install

	mv "${ED}/usr/bin/gitview" "${ED}/usr/bin/gnuitview" || die
}

pkg_postinst() {
	elog "The 'git' tool this package previously installed is now called 'gitfm'"
	elog "The 'gitview' tool this package previously installed is now called 'gnuitview'"
	elog "If you want the 'gitaction' tool to use your preferred desktop"
	elog "application settings install the 'x11-misc/xdg-utils' package."
}

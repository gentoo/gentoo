# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/fbiterm/fbiterm-0.5-r2.ebuild,v 1.3 2012/08/19 00:33:24 mr_bones_ Exp $

EAPI=4

inherit autotools-utils eutils multilib

IUSE=""

DESCRIPTION="Framebuffer internationalized terminal emulator"
HOMEPAGE="http://www-124.ibm.com/linux/projects/iterm/"
SRC_URI="http://www-124.ibm.com/linux/projects/iterm/releases/iterm-${PV}.tar.gz"

LICENSE="CPL-0.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/libXfont
	>=media-libs/freetype-2
	x11-libs/libiterm-mbt
	sys-libs/zlib"
RDEPEND="${DEPEND}
	media-fonts/font-sony-misc
	media-fonts/unifont"

PATCHES=(
	"${FILESDIR}"/${PF}-gentoo.diff
	"${FILESDIR}"/${P}-cflags.patch
)
DOCS=( AUTHORS ChangeLog README{,.jp,.zh_CN} )
AUTOTOOLS_AUTORECONF=1

S="${WORKDIR}/iterm/unix/fbiterm"

src_configure() {
	local myeconfargs=(
		--x-includes=/usr/include
		--x-libraries=/usr/$(get_libdir)
	)
	autotools-utils_src_configure
}

pkg_postinst() {
	elog
	elog "1. If you haven't created your locale, run localedef."
	elog "# localedef -v -c -i en_GB -f UTF-8 en_GB.UTF-8"
	elog "(If you want to use other locales such as Japanese, replace"
	elog "en_GB with ja_JP and en_GB.UTF-8 with ja_JP.UTF-8, respectively)"
	elog
	elog "2. Set enviroment variable."
	elog "% export LC_CTYPE=en_GB.UTF-8 (sh, bash, zsh, ...)"
	elog "> setenv LC_CTYPE en_GB.UTF-8 (csh, tcsh, ...)"
	elog "(Again, if you want to use Japanese locale, create ja_JP.UTF-8"
	elog " locale by localedef and set LC_CTYPE to ja_JP.UTF-8)"
	elog
	elog "3. Run unicode_start."
	elog "% unicode_start"
	elog
	elog "4. Run fbiterm."
	elog "% fbiterm"
	elog
}

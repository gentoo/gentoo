# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="A collection of Gentoo themes for splashutils"
HOMEPAGE="https://dev.gentoo.org/~spock/"
SRC_URI="mirror://gentoo/fbsplash-theme-emergence-r2.tar.bz2
	 mirror://gentoo/fbsplash-theme-gentoo-r2.tar.bz2
	 mirror://gentoo/fbsplash-theme-emerge-world-1.0.tar.bz2
	 http://fbsplash.berlios.de/themes/repo/natural_gentoo-9.0-r2.tar.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=media-gfx/splashutils-1.1.9.5[png]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"
RESTRICT="binchecks strip"

src_prepare() {
	sed -i -e 's/natural-gentoo/natural_gentoo/g' natural_gentoo/*.cfg || die 'sed failed'
}

src_install() {
	insinto /etc/splash
	doins -r *
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "The upstream tarball for the 'Natural Gentoo' theme also contains a GRUB"
		elog "splash image which is not installed by this ebuild.  See:"
		elog "  http://www.kde-look.org/content/show.php?content=49074"
		elog "if you are interested in this."
	fi
}

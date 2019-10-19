# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/-/_}.orig"

DESCRIPTION="Fontset for KON2"
# There seems to be no real homepage for this package
HOMEPAGE="https://packages.debian.org/stable/utils/konfont"
SRC_URI="mirror://debian/dists/potato/main/source/utils/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT=0
KEYWORDS="alpha amd64 arm hppa ia64 ppc s390 sh sparc x86"
# Only installs fonts
RESTRICT="strip binchecks"

S="${WORKDIR}/${MY_P/_/-}/fonts"

src_install() {
	insinto /usr/share/fonts
	doins pubfont.*.gz
}

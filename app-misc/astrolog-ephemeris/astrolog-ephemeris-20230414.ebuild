# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This archive is most probably created from files from following repository
# https://github.com/aloistr/swisseph/tree/master/ephe
#
# The version represents archive creation date.
#
# Upstream calls them Swiss Ephemeris files and Astrolog version 7.70 (most
# recent version in time of writing this comment) tries to search them by
# default.

DESCRIPTION="ephemeris files for optional extended accuracy of astrolog's calculations"
HOMEPAGE="https://www.astrolog.org/astrolog.htm"
SRC_URI="
	https://www.astrolog.org/ftp/ephem/astephem.zip
		-> ${P}.zip
"

S="${WORKDIR}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"

RDEPEND="app-misc/astrolog"
BDEPEND="app-arch/unzip"

src_install() {
	insinto /usr/share/astrolog
	doins -r .
}

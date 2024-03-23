# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="mdoc port of the HTML documentation for the s6 suite"
HOMEPAGE="https://git.sr.ht/~flexibeast/s6-man-pages"
SRC_URI="
	https://git.sr.ht/~flexibeast/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

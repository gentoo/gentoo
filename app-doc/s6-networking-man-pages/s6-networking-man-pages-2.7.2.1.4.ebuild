# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="mdoc port of the HTML documentation for the s6 suite"
HOMEPAGE="https://git.sr.ht/~humm/s6-man-pages"
SRC_URI="https://git.sr.ht/~humm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

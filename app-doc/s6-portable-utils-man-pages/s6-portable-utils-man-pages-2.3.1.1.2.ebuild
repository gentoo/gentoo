# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="mdoc port of the HTML documentation for the s6-portable-utils suite"
HOMEPAGE="https://git.sr.ht/~humm/s6-portable-utils-man-pages"
SRC_URI="https://git.sr.ht/~humm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

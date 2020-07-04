# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="NPAPI headers bundle"
HOMEPAGE="https://github.com/mgorny/npapi-sdk/"
EGIT_REPO_URI="https://github.com/mgorny/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

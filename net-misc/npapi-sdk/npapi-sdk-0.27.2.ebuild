# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools-utils

DESCRIPTION="NPAPI headers bundle"
HOMEPAGE="https://github.com/mgorny/npapi-sdk/"
SRC_URI="https://github.com/mgorny/npapi-sdk/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="virtual/pkgconfig"

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils fortran-2

DESCRIPTION="Application Programming Interface for atomistic simulations"
HOMEPAGE="https://openkim.org"
SRC_URI="https://s3.openkim.org/${PN}/${P}.txz"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

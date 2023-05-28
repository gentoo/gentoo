# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Implementation of the Double Ratchet cryptographic ratchet in C++"
HOMEPAGE="https://gitlab.matrix.org/matrix-org/olm"
SRC_URI="https://gitlab.matrix.org/matrix-org/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

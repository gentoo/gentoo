# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Parsing Expressions with Strings, Complex Numbers, Vectors, Matrices and more"
HOMEPAGE="https://beltoforion.de/en/muparser/"
SRC_URI="https://github.com/beltoforion/muparserx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"/muparserx-${PV}

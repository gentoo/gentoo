# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P="${PN}${PV}_src"

DESCRIPTION="Fast, accurate chimera detection"
HOMEPAGE="https://www.drive5.com/usearch/manual/uchime_algo.html"
SRC_URI="https://www.drive5.com/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

PATCHES=( "${FILESDIR}"/CMakeLists.patch )

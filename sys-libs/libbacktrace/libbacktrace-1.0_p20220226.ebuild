# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C library that may be linked into a C/C++ program to produce symbolic backtraces"
HOMEPAGE="https://github.com/ianlancetaylor/libbacktrace"

MY_COMMIT="2446c66076480ce07a6bd868badcbceb3eeecc2e"

SRC_URI="https://github.com/ianlancetaylor/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

S=${WORKDIR}/${PN}-${MY_COMMIT}

#RDEPEND=""
#DEPEND="${RDEPEND}"

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64 ~ppc64"
SRC_URI="https://github.com/martinus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Fast & memory efficient hashtable based on robin hood hashing for C++11/14/17/20"
HOMEPAGE="https://github.com/martinus/robin-hood-hashing"

LICENSE="MIT"
SLOT="0"

src_install() {
	insinto /usr/include
	doins src/include/robin_hood.h
}

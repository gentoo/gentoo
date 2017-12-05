# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="ck"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A library with concurrency related algorithms and data structures in C"
HOMEPAGE="http://concurrencykit.org"
SRC_URI="http://concurrencykit.org/releases/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

# libck.so name collision #616762
# these packages have nothing in common
RDEPEND="!sys-cluster/charm"

S="${WORKDIR}/${MY_P}"

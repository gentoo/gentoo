# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="ck"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A library with concurrency related algorithms and data structures in C"
HOMEPAGE="http://concurrencykit.org"
SRC_URI="https://github.com/concurrencykit/ck/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

# libck.so name collision #616762
# these packages have nothing in common
RDEPEND="!sys-cluster/charm"

# https://github.com/concurrencykit/ck/issues/147
# https://github.com/concurrencykit/ck/issues/150
PATCHES=(
	"${FILESDIR}/${PN}-glibc-2.30.patch"
	"${FILESDIR}/${PN}-doc.patch"
)

S="${WORKDIR}/${MY_P}"

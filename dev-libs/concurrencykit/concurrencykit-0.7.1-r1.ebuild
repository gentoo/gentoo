# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_PN="ck"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A library with concurrency related algorithms and data structures in C"
HOMEPAGE="http://concurrencykit.org"
SRC_URI="https://github.com/${PN}/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

# The 'libck.so' has a name collision.
# See bug #616762 for more information.
RDEPEND="!sys-cluster/charm"

src_configure() {
	# https://github.com/concurrencykit/ck/issues/200
	append-cflags -fno-strict-aliasing

	tc-export AR CC LD

	local myeconfargs=(
		"--disable-static"
	)

	GZIP="" econf ${myeconfargs[@]}
}

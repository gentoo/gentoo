# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_TESTS=1
OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="A modular standard library focused on data structures"
HOMEPAGE="https://github.com/c-cube/ocaml-containers"
SRC_URI="https://github.com/c-cube/ocaml-containers/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/result:=
	>=dev-ml/sequence-0.9:=
"
DEPEND="${RDEPEND} dev-ml/cppo
	test? ( dev-ml/iTeML dev-ml/ounit dev-ml/gen )"

src_configure() {
	oasis_configure_opts="
		--enable-unix
		--disable-bench
	" oasis_src_configure
}

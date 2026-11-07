# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

# Upstream is moving tags repeatedly, then we use commit hash.
RELEASE_COMMIT="ed7b992dbd0b5c8946ce3d9a3fdf2239dcb75a58" #tag v3.3-latest

inherit autotools python-single-r1

DESCRIPTION="Simple C language RPC framework"
HOMEPAGE="https://github.com/haiwen/libsearpc/ https://seafile.com/"
SRC_URI="https://github.com/haiwen/${PN}/archive/${RELEASE_COMMIT}.tar.gz -> ${P}-r5.tar.gz"
S="${WORKDIR}/${PN}-${RELEASE_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.26.0
	>=dev-libs/jansson-2.2.1:="
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	# Remove unnecessary .la files
	find "${ED}" -name '*.la' -delete || die
}

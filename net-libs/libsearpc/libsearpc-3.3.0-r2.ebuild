# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

# Upstream is moving tags repeatedly, then we use commit hash.
RELEASE_COMMIT="15f6f0b9f451b9ecf99dedab72e9242e54e124eb" #tag v3.3-latest

inherit autotools python-single-r1

DESCRIPTION="A simple C language RPC framework"
HOMEPAGE="https://github.com/haiwen/libsearpc/ http://seafile.com/"
SRC_URI="https://github.com/haiwen/${PN}/archive/${RELEASE_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.26.0
	>=dev-libs/jansson-2.2.1:="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${RELEASE_COMMIT}"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch #870544
)

src_prepare() {
	default
	sed -i -e "s/(DESTDIR)//" ${PN}.pc.in || die
	eautoreconf
}

src_install() {
	default
	# Remove unnecessary .la files
	find "${ED}" -name '*.la' -delete || die
}

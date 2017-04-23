# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_{4,5} )

inherit multilib python-single-r1 cmake-utils

DESCRIPTION="lensfun: A library for rectifying and simulating photographic lens distortions"
HOMEPAGE="http://lensfun.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-3 CC-BY-SA-3.0" # See README for reasoning.
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="doc cpu_flags_x86_sse cpu_flags_x86_sse2 test"

RDEPEND=">=dev-libs/glib-2.28
	media-libs/libpng:0=
	sys-libs/zlib:=
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		dev-python/docutils
	)"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS=( README.md docs/mounts.txt ChangeLog )

src_configure() {
	local mycmakeargs=(
		-DDOCDIR="${EPREFIX}"/usr/share/doc/${PF}/html
		-DLIBDIR="${EPREFIX}"/usr/$(get_libdir)
		-DSETUP_PY_INSTALL_PREFIX="${ED}"/$(python_get_sitedir)
		-DBUILD_AUXFUN=ON
		-DBUILD_DOC=$(usex doc ON OFF)
		-DBUILD_FOR_SSE=$(usex cpu_flags_x86_sse ON OFF)
		-DBUILD_FOR_SSE2=$(usex cpu_flags_x86_sse2 ON OFF)
		-DBUILD_TESTS=$(usex test ON OFF)
		-DBUILD_STATIC=OFF
	)

	cmake-utils_src_configure
}

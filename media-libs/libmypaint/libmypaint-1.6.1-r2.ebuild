# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit python-any-r1 toolchain-funcs

MY_PV=${PV/_beta/-beta.}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Library for making brushstrokes"
HOMEPAGE="https://github.com/mypaint/libmypaint"
SRC_URI="https://github.com/mypaint/libmypaint/releases/download/v${MY_PV}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="ISC"
# See https://github.com/mypaint/libmypaint/releases/tag/v1.6.1
# https://github.com/mypaint/libmypaint/compare/v1.6.0...v1.6.1
SLOT="0/0.0.0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv x86"
IUSE="gegl introspection nls openmp"

BDEPEND="
	${PYTHON_DEPS}
	nls? ( dev-util/intltool )
"
DEPEND="
	dev-libs/glib:2
	dev-libs/json-c:=
	gegl? (
		media-libs/babl[introspection?]
		>=media-libs/gegl-0.4.14:0.4[introspection?]
	)
	introspection? ( >=dev-libs/gobject-introspection-1.32 )
	nls? ( sys-devel/gettext )
"
RDEPEND="
	${DEPEND}
	!<media-gfx/mypaint-1.2.1
"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	python-any-r1_pkg_setup
}

src_configure() {
	tc-ld-disable-gold # bug 589266

	econf \
		--disable-debug \
		--disable-docs \
		$(use_enable gegl) \
		--disable-gperftools \
		$(use_enable nls i18n) \
		$(use_enable introspection) \
		$(use_enable openmp) \
		--disable-profiling
}

src_install() {
	default
	find "${ED}" -name '*.la' -type f -delete || die
}

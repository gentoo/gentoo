# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit autotools python-any-r1 xdg-utils toolchain-funcs

MY_PV=${PV/_beta/-beta.}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Library for making brushstrokes"
HOMEPAGE="https://github.com/mypaint/libmypaint"
SRC_URI="https://github.com/mypaint/libmypaint/releases/download/v${MY_PV}/${MY_P}.tar.xz"

LICENSE="ISC"
SLOT="0/$(ver_cut 1-2)"  # https://github.com/mypaint/libmypaint/wiki/Versioning
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~ppc ppc64 ~x86"
IUSE="gegl introspection nls openmp"

CDEPEND="
	dev-libs/glib:2
	dev-libs/json-c:=
	gegl? (
		media-libs/babl
		>=media-libs/gegl-0.4.14:0.4[introspection?]
	)
	introspection? ( >=dev-libs/gobject-introspection-1.32 )
	openmp? ( >sys-devel/gcc-5:*[openmp] )
	nls? ( sys-devel/gettext )
	"
DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	nls? ( dev-util/intltool )
	"
RDEPEND="${CDEPEND}
	!<media-gfx/mypaint-1.2.1
	"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.0-drop-libmypaint-gegl-versioning.patch
	"${FILESDIR}"/${PN}-1.4.0-gegl-0.4.14.patch
	"${FILESDIR}"/${PN}-1.4.0-adjust-generation-script-to-be-runnable-in-Py3.patch
	"${FILESDIR}"/${PN}-1.4.0-drop-python2-requirement-recommendation.patch
)

src_prepare() {
	xdg_environment_reset
	default
	eautoreconf
}

src_configure() {
	tc-ld-disable-gold  # bug 589266
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
	find "${D}" -name '*.la' -type f -delete || die
}

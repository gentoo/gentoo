# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils python-any-r1 xdg-utils toolchain-funcs

MY_PV=${PV/_beta/-beta.}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Library for making brushstrokes"
HOMEPAGE="https://github.com/mypaint/libmypaint"
SRC_URI="https://github.com/mypaint/libmypaint/releases/download/v${MY_PV}/${MY_P}.tar.xz"

LICENSE="ISC"
SLOT="0/0"  # first soname component for subslot
KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86"
IUSE="gegl introspection nls openmp"

CDEPEND="
	dev-libs/glib:2
	dev-libs/json-c
	gegl? (
		media-libs/babl
		media-libs/gegl:0.3[introspection?]
	)
	introspection? ( >=dev-libs/gobject-introspection-1.32 )
	openmp? ( sys-devel/gcc:*[openmp] )
	nls? ( sys-devel/gettext )
	"
DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	nls? ( dev-util/intltool )
	"
RDEPEND="${CDEPEND}
	!<media-gfx/mypaint-1.2.2
	"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	xdg_environment_reset
	epatch "${FILESDIR}"/${PN}-1.3.0_beta1-as-needed.patch
	eapply_user
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

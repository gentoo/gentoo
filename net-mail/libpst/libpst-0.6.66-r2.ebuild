# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit autotools python-single-r1

DESCRIPTION="Tools and library for reading Outlook files (.pst format)"
HOMEPAGE="https://www.five-ten-sg.com/libpst/"
SRC_URI="https://www.five-ten-sg.com/${PN}/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="debug dii doc python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	gnome-extra/libgsf:=
	dii? ( media-gfx/imagemagick:=[png] )
	python? (
		${PYTHON_DEPS}
		>=dev-libs/boost-1.70:=[python,${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	virtual/libiconv
	virtual/pkgconfig
	dii? ( media-libs/gd[png] )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# don't build the static python library
	eapply "${FILESDIR}"/${PN}-0.6.52-no-static-python-lib.patch

	# fix pkgconfig file for static linking
	eapply "${FILESDIR}"/${PN}-0.6.53-pkgconfig-static.patch

	# conditionally install the extra documentation
	if ! use doc; then
		sed -i -e "/SUBDIRS/s: html::" Makefile.am || die
	fi

	# don't install duplicate docs
	sed -i -e "/^html_DATA =/d" Makefile.am || die

	eapply_user

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-libpst-shared \
		$(use_enable debug pst-debug) \
		$(use_enable dii) \
		$(use_enable python) \
		$(use_enable static-libs static) \
		$(use_with python boost-python "boost_${EPYTHON/./}")
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

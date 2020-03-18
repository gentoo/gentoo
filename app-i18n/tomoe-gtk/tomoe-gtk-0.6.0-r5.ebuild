# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit ltprune python-single-r1

DESCRIPTION="Tomoe GTK+ interface widget library"
HOMEPAGE="http://tomoe.osdn.jp/"
SRC_URI="mirror://sourceforge/tomoe/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="app-i18n/tomoe[python(+)?,${PYTHON_SINGLE_USEDEP}]
	x11-libs/gtk+:2
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pygobject:2[${PYTHON_MULTI_USEDEP}]
			dev-python/pygtk:2[${PYTHON_MULTI_USEDEP}]
		')
	)"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with python python "") \
		--without-gucharmap
}

src_install() {
	default
	prune_libtool_files --modules
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python2_7)

inherit eutils toolchain-funcs linux-info python-single-r1

DESCRIPTION="User-space front-end for Ftrace"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/rostedt/trace-cmd.git"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc gtk python udis86"

RDEPEND="python? ( ${PYTHON_DEPS} )
	udis86? ( dev-libs/udis86 )
	gtk? (
		${PYTHON_DEPS}
		dev-python/pygtk:2[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	python? (
		virtual/pkgconfig
		dev-lang/swig
	)
	gtk? ( virtual/pkgconfig )
	doc? ( app-text/asciidoc )"

CONFIG_CHECK="
	~TRACING
	~FTRACE
	~BLK_DEV_IO_TRACE"

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch_user
}

src_configure() {
	MAKEOPTS+=" prefix=/usr libdir=$(get_libdir) CC=$(tc-getCC) AR=$(tc-getAR)"

	if use python; then
		MAKEOPTS+=" PYTHON_VERS=${EPYTHON//python/python-}"
		MAKEOPTS+=" python_dir=$(python_get_sitedir)/${PN}"
	else
		MAKEOPTS+=" NO_PYTHON=1"
	fi

	use udis86 || MAKEOPTS+=" NO_UDIS86=1"
}

src_compile() {
	emake all_cmd
	use doc && emake doc
	use gtk && emake -j1 gui
}

src_install() {
	emake DESTDIR="${D}" install
	use doc && emake DESTDIR="${D}" install_doc
	use gtk && emake DESTDIR="${D}" install_gui
}

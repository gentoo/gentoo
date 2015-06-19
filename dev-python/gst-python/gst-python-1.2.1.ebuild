# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gst-python/gst-python-1.2.1.ebuild,v 1.12 2015/04/08 08:05:05 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit python-r1

DESCRIPTION="A Python Interface to GStreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="1.0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="test" #examples , bug #506962

RDEPEND="
	dev-libs/libxml2
	>=dev-python/pygobject-3:3[${PYTHON_USEDEP}]
	>=media-libs/gstreamer-1.2:1.0
	>=media-libs/gst-plugins-base-1.2:1.0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
# XXX: unittests are not ported to 1.0 yet.

src_prepare() {
	# Leave examples alone
	sed -e 's/\(SUBDIRS = .*\)examples/\1/' \
		-i Makefile.am Makefile.in || die

	prepare_gst() {
		mkdir -p "${BUILD_DIR}" || die
	}
	python_foreach_impl prepare_gst
}

src_configure() {
	ECONF_SOURCE="${S}" python_foreach_impl run_in_build_dir econf
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	python_foreach_impl run_in_build_dir default
	prune_libtool_files --modules
	einstalldocs

#	if use examples; then
#		docinto examples
#		dodoc examples/*
#	fi
}

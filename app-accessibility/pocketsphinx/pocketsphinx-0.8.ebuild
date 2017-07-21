# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1
inherit eutils distutils-r1

DESCRIPTION="Speaker-independent large vocabulary with continuous speech recognizer"
HOMEPAGE="https://sourceforge.net/projects/cmusphinx/"
SRC_URI="mirror://sourceforge/cmusphinx/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="app-accessibility/sphinxbase
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

run_distutils() {
	if use python; then
		pushd python > /dev/null || die
		distutils-r1_"${@}"
		popd > /dev/null || die
	fi
}

src_configure() {
	econf \
		--without-python \
		$(use_enable static-libs static)
}

src_compile() {
	default
	run_distutils ${FUNCNAME}
}

src_install() {
	default
	run_distutils ${FUNCNAME}
	prune_libtool_files
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils distutils-r1

DESCRIPTION="Support library required by the Sphinx Speech Recognition Engine"
HOMEPAGE="http://cmusphinx.sourceforge.net/"
SRC_URI="mirror://sourceforge/cmusphinx/${P}.tar.gz"

LICENSE="BSD-2 HPND MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc lapack python static-libs"

# automagic dep on pulseaudio
RDEPEND="
	media-sound/pulseaudio
	lapack? ( virtual/lapack )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.4.7 )"

# Due to generated Python setup.py.
AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/${P}-unbundle-lapack.patch
	"${FILESDIR}"/${P}-automake113.patch
)

src_configure() {
	local myeconfargs=(
		$(use_with lapack)
		$(use_enable doc)
		# python modules are built through distutils
		# so disable the ugly wrapper
		--without-python
	)
	autotools-utils_src_configure
}

run_distutils() {
	if use python; then
		pushd python > /dev/null || die
		distutils-r1_"${@}"
		popd > /dev/null || die
	fi
}

src_compile() {
	autotools-utils_src_compile

	run_distutils ${FUNCNAME}
}

python_test() {
	LD_LIBRARY_PATH="${S}"/src/lib${PN}/.libs \
		"${PYTHON}" sb_test.py || die "Tests fail with ${EPYTHON}"
}

src_test() {
	autotools-utils_src_test

	run_distutils ${FUNCNAME}
}

src_install() {
	run_distutils ${FUNCNAME}

	use doc && local HTML_DOCS=( doc/html/. )
	autotools-utils_src_install
}

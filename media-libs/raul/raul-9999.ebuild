# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE='threads(+)'

inherit waf-utils python-any-r1 eutils git-r3

DESCRIPTION="C++ utility library primarily aimed at audio/musical applications"
HOMEPAGE="http://wiki.drobilla.net/Raul"
EGIT_REPO_URI="https://gitlab.com/drobilla/raul.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/boost
	dev-libs/glib"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

RAUL_TESTS="atomic_test atom_test list_test midi_ringbuffer_test path_test quantize_test queue_test ringbuffer_test smf_test table_test thread_test time_test"
DOCS=( AUTHORS NEWS README )

src_configure() {
	waf-utils_src_configure \
		$(use debug && echo "--debug") \
		$(use doc && echo "--docs") \
		$(use test && echo "--test")
}

src_test() {
	cd "${S}/build/test" || die
	for i in ${RAUL_TESTS} ; do
		einfo "Running test ${i}"
		LD_LIBRARY_PATH=.. ./${i} || die
	done
}

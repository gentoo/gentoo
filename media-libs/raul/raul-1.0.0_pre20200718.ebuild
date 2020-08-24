# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE='threads(+)'

inherit waf-utils python-any-r1 eutils

COMMIT="496e70e420811c7d744a8bcc44a2ac1b51b676b5"
COMMIT_AUTOWAF="6c6c1d29bfe4c28dd26b5cde7ea4a1a148ee700d"

DESCRIPTION="C++ utility library primarily aimed at audio/musical applications"
HOMEPAGE="http://wiki.drobilla.net/Raul"
SRC_URI="https://gitlab.com/drobilla/raul/-/archive/${COMMIT}.tar.bz2 -> ${P}.tar.bz2
	https://gitlab.com/drobilla/autowaf/-/archive/${COMMIT_AUTOWAF}.tar.bz2 -> drobilla-autowaf.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/boost
	dev-libs/glib"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}-${COMMIT}"

RAUL_TESTS="array_test build_test double_buffer_test maid_test path_test ringbuffer_test sem_test socket_test symbol_test thread_test time_test"
DOCS=( AUTHORS NEWS README )

src_prepare() {
	default
	rm -r "${S}/waflib" || die
	ln -s "${WORKDIR}/autowaf-${COMMIT_AUTOWAF}" "${S}/waflib" || die
}

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

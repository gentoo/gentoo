# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit cmake-utils python-r1

# change each release, to avoid git in tree dependency
DYND_GIT_SHA1=e5578b6b862c025dd757f77aaae69be48cde5613

DESCRIPTION="Python exposure of multidimensionnal array library libdynd"
HOMEPAGE="https://github.com/ContinuumIO/dynd-python"
SRC_URI="https://github.com/ContinuumIO/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

IUSE="doc test"

RDEPEND="
	~dev-libs/libdynd-${PV}
	>=dev-python/numpy-1.5[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-python/cython-0.19[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

PATCHES=( "${FILESDIR}"/${PN}-0.6.2-out-of-git-versioning.patch )

src_prepare() {
	cmake-utils_src_prepare
	# each relase comes with a different set...
	# remove forced strong flags
	sed -i \
		-e "s|@DYND_GIT_SHA1@|${DYND_GIT_SHA1}|" \
		-e "s|@DYND_VERSION@|${PV}|" \
		-e 's|-g -fomit-frame-pointer||' \
		-e 's|-Werror||g' \
		CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SEPARATE_LIBDYND=ON
		-DDYND_INSTALL_LIB=ON
		$(cmake-utils_use test DYND_BUILD_TESTS)
	)
	python_foreach_impl cmake-utils_src_configure
}

src_compile() {
	python_foreach_impl cmake-utils_src_make
	use doc && emake -C doc html
}

src_test() {
	testing() {
		cmake-utils_src_make DESTDIR="${WORKDIR}-test-${EPYTHON}" install
		cd "${WORKDIR}-test-${EPYTHON}"/$(python_get_sitedir) || die
		${PYTHON} -c 'import dynd; dynd.test()' || die
	}
	python_foreach_impl testing
}

src_install() {
	python_foreach_impl cmake-utils_src_install
	dodoc README.md
	use doc && dohtml -r doc/build/html/*
}

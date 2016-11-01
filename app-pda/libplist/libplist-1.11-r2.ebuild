# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
inherit autotools eutils python-r1

DESCRIPTION="Support library to deal with Apple Property Lists (Binary & XML)"
HOMEPAGE="http://www.libimobiledevice.org/"
SRC_URI="http://www.libimobiledevice.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/2" # based on SONAME of libplist.so
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd"
IUSE="python static-libs"

RDEPEND=">=dev-libs/libxml2-2.7.8
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? ( >=dev-python/cython-0.17[${PYTHON_USEDEP}] )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS=( AUTHORS NEWS README )

RESTRICT="test" # TODO: src_test() was dropped from 1.10 (cmake) -> 1.11 (autotools)

BUILD_DIR="${S}_build"

src_configure() {
	local ECONF_SOURCE=${S}
	local myeconfargs=( $(use_enable static-libs static) )

	do_configure() {
		mkdir -p "${BUILD_DIR}" || die
		pushd "${BUILD_DIR}" >/dev/null || die
		econf "${myeconfargs[@]}" "${@}"
		popd >/dev/null || die
	}

	do_configure_python() {
		PYTHON_LDFLAGS="$(python_get_LIBS)" do_configure "$@"
	}

	do_configure --without-cython
	use python && python_foreach_impl do_configure_python
}

src_compile() {
	python_compile() {
		emake -C "${BUILD_DIR}"/cython -j1 \
			VPATH="${S}/cython:${native_builddir}/cython" \
			plist_la_LIBADD="${native_builddir}/src/libplist.la"
	}

	local native_builddir=${BUILD_DIR}
	pushd "${BUILD_DIR}" >/dev/null || die
	emake -j1
	use python && python_foreach_impl python_compile
	popd >/dev/null || die
}

src_install() {
	python_install() {
		emake -C "${BUILD_DIR}/cython" -j1 \
			VPATH="${S}/cython:${native_builddir}/cython" \
			DESTDIR="${D}" install
	}

	local native_builddir=${BUILD_DIR}
	pushd "${BUILD_DIR}" >/dev/null || die
	emake -j1 DESTDIR="${D}" install
	use python && python_foreach_impl python_install
	popd >/dev/null || die

	if use python ; then
		insinto /usr/include/plist/cython
		doins cython/plist.pxd
	fi
	prune_libtool_files --all
}

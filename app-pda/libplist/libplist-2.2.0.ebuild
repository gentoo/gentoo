# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit autotools python-r1 toolchain-funcs

DESCRIPTION="Support library to deal with Apple Property Lists (Binary & XML)"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://cgit.libimobiledevice.org/${PN}.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="python static-libs"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	python? ( >=dev-python/cython-0.17[${PYTHON_USEDEP}] )
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DOCS=( AUTHORS NEWS README.md )

BUILD_DIR="${S}_build"

src_prepare() {
	default
	eautoreconf
}

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
		local -x PYTHON_LDFLAGS="$(python_get_LIBS)"
		do_configure "$@"
	}

	# Don't prefer clang.
	tc-export CC CXX

	do_configure --without-cython
	use python && python_foreach_impl do_configure_python
}

src_compile() {
	python_compile() {
		emake -C "${BUILD_DIR}"/cython \
			VPATH="${S}/cython:${native_builddir}/cython" \
			plist_la_LIBADD="${native_builddir}/src/libplist.la"
	}

	local native_builddir=${BUILD_DIR}
	pushd "${BUILD_DIR}" >/dev/null || die
	emake
	use python && python_foreach_impl python_compile
	popd >/dev/null || die
}

src_test() {
	emake -C "${BUILD_DIR}" check
}

src_install() {
	python_install() {
		emake -C "${BUILD_DIR}/cython" \
			VPATH="${S}/cython:${native_builddir}/cython" \
			DESTDIR="${D}" install
	}

	local native_builddir=${BUILD_DIR}
	pushd "${BUILD_DIR}" >/dev/null || die
	emake DESTDIR="${D}" install
	use python && python_foreach_impl python_install
	popd >/dev/null || die

	einstalldocs

	if use python ; then
		insinto /usr/include/plist/cython
		doins cython/plist.pxd
	fi

	find "${D}" -name '*.la' -delete || die
}

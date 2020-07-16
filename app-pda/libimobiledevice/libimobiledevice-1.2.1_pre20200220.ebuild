# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="3d8d13f0a70cefc1b12571b7f6aa2d1d4c58cffb"
PYTHON_COMPAT=( python3_{6,7,8} )

inherit autotools python-r1

DESCRIPTION="Support library to communicate with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://cgit.libimobiledevice.org/libimobiledevice.git/snapshot/libimobiledevice-${COMMIT}.tar.bz2 -> ${P}.tar.bz2"

# While COPYING* doesn't mention 'or any later version', all the headers do, hence use +
LICENSE="GPL-2+ LGPL-2.1+"

SLOT="0/6" # based on SONAME of libimobiledevice.so

KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 x86"
IUSE="doc gnutls libressl python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=app-pda/libplist-1.11:=
	>=app-pda/libusbmuxd-1.1.0:=
	gnutls? (
		dev-libs/libgcrypt:0
		>=dev-libs/libtasn1-1.1
		>=net-libs/gnutls-2.2.0 )
	!gnutls? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= ) )
	python? (
		${PYTHON_DEPS}
		app-pda/libplist[python(-),${PYTHON_USEDEP}] )
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	python? ( >=dev-python/cython-0.17[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/${PN}-${COMMIT}"
BUILD_DIR="${S}_build"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local ECONF_SOURCE=${S}

	local myeconfargs=( $(use_enable static-libs static) )
	use gnutls && myeconfargs+=( --disable-openssl )

	do_configure() {
		mkdir -p "${BUILD_DIR}" || die
		pushd "${BUILD_DIR}" >/dev/null || die
		econf "${myeconfargs[@]}" "${@}"
		popd >/dev/null || die
	}

	do_configure_python() {
		# Bug 567916
		local -x PYTHON_LDFLAGS="$(python_get_LIBS)"
		do_configure "$@"
	}

	do_configure --without-cython
	use python && python_foreach_impl do_configure_python
}

src_compile() {
	python_compile() {
		emake -C "${BUILD_DIR}"/cython \
			VPATH="${S}/cython:$1/cython" \
			imobiledevice_la_LIBADD="$1/src/libimobiledevice.la"
	}

	emake -C "${BUILD_DIR}"
	use python && python_foreach_impl python_compile "${BUILD_DIR}"

	if use doc; then
		doxygen "${BUILD_DIR}"/doxygen.cfg || die
	fi
}

src_install() {
	python_install() {
		emake -C "${BUILD_DIR}/cython" install \
			DESTDIR="${D}" \
			VPATH="${S}/cython:$1/cython"
	}

	emake -C "${BUILD_DIR}" install DESTDIR="${D}"
	use python && python_foreach_impl python_install "${BUILD_DIR}"
	use doc && dodoc docs/html/*

	if use python; then
		insinto /usr/include/${PN}/cython
		doins cython/imobiledevice.pxd
	fi

	find "${D}" -name '*.la' -delete || die
}

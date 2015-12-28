# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
inherit eutils python-r1

DESCRIPTION="Support library to communicate with Apple iPhone/iPod Touch devices"
HOMEPAGE="http://www.libimobiledevice.org/"
SRC_URI="http://www.libimobiledevice.org/downloads/${P}.tar.bz2"

# While COPYING* doesn't mention 'or any later version', all the headers do, hence use +
LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/4" # based on SONAME of libimobiledevice.so
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="gnutls python static-libs"

RDEPEND=">=app-pda/libplist-1.11:=
	>=app-pda/libusbmuxd-1.0.9:=
	gnutls? (
		dev-libs/libgcrypt:0
		>=dev-libs/libtasn1-1.1
		>=net-libs/gnutls-2.2.0
		)
	!gnutls? ( dev-libs/openssl:0 )
	python? (
		${PYTHON_DEPS}
		app-pda/libplist[python(-),${PYTHON_USEDEP}]
		)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? ( >=dev-python/cython-0.17[${PYTHON_USEDEP}] )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS=( AUTHORS NEWS README )

BUILD_DIR="${S}_build"

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

	do_configure --without-cython
	use python && python_foreach_impl do_configure
}

src_compile() {
	python_compile() {
		emake -C "${BUILD_DIR}"/cython -j1 \
			VPATH="${S}/cython:${native_builddir}/cython" \
			imobiledevice_la_LIBADD="${native_builddir}/src/libimobiledevice.la"
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

	dodoc docs/html/*
	if use python; then
		insinto /usr/include/${PN}/cython
		doins cython/imobiledevice.pxd
	fi
	prune_libtool_files --all
}

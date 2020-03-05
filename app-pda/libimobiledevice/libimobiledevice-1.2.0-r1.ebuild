# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit autotools python-r1

DESCRIPTION="Support library to communicate with Apple iPhone/iPod Touch devices"
HOMEPAGE="http://www.libimobiledevice.org/"

# Get patches from Fedora
SRC_URI="http://www.libimobiledevice.org/downloads/${P}.tar.bz2
	https://src.fedoraproject.org/rpms/libimobiledevice/raw/master/f/0001-userpref-GnuTLS-Fix-3.6.0-SHA1-compatibility.patch -> ${P}-userpref-GnuTLS-Fix-3.6.0-SHA1-compatibility.patch
	https://src.fedoraproject.org/rpms/libimobiledevice/raw/master/f/0002-userpref-GnuTLS-Use-valid-serial-for-3.6.0.patch -> ${P}-userpref-GnuTLS-Use-valid-serial-for-3.6.0.patch
	https://src.fedoraproject.org/rpms/libimobiledevice/raw/master/f/344409e1d1ad917d377b256214c5411dda82e6b0...5a85432719fb3d18027d528f87d2a44b76fd3e12.patch -> ${P}-git.patch"

# While COPYING* doesn't mention 'or any later version', all the headers do, hence use +
LICENSE="GPL-2+ LGPL-2.1+"

SLOT="0/6" # based on SONAME of libimobiledevice.so

KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 x86"
IUSE="gnutls libressl python static-libs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=app-pda/libplist-1.11:=
	>=app-pda/libusbmuxd-1.0.9:=
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
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? ( >=dev-python/cython-0.17[${PYTHON_USEDEP}] )
"

BUILD_DIR="${S}_build"

PATCHES=(
	"${DISTDIR}"/${P}-git.patch
	"${DISTDIR}"/${P}-userpref-GnuTLS-Fix-3.6.0-SHA1-compatibility.patch
	"${DISTDIR}"/${P}-userpref-GnuTLS-Use-valid-serial-for-3.6.0.patch
)

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

	find "${D}" -name '*.la' -delete || die
}

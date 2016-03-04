# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit flag-o-matic python-r1

MY_P="PyQwt-${PV}"
DESCRIPTION="Python bindings for the Qwt library"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
HOMEPAGE="http://pyqwt.sourceforge.net/"

SLOT="5"
LICENSE="GPL-2"
KEYWORDS="amd64 arm ia64 x86"
IUSE="debug doc examples svg"

RDEPEND="
	x11-libs/qwt:5[svg?]
	dev-python/PyQt4[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	dev-python/sip[${PYTHON_USEDEP}]
	~dev-python/PyQt4-4.11.1[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}/configure"

src_prepare() {
	python_copy_sources
	append-flags -fPIC
}

src_configure() {
	configuration() {
		local myonf=()
		use debug && myconf+=( --debug )

		cd "${BUILD_DIR}" || die
		# '-j' option can be buggy.
		"${PYTHON}" configure.py \
			--extra-cflags="${CFLAGS}" \
			--extra-cxxflags="${CXXFLAGS}" \
			--extra-lflags="${LDFLAGS}" \
			--disable-numarray \
			--disable-numeric \
			-I/usr/include/qwt5 \
			-lqwt \
			${myconf[@]} \
			|| die "configure.py failed"

		# Avoid stripping of the libraries.
		sed -i -e "/strip/d" {iqt5qt4,qwt5qt4}/Makefile || die "sed failed"
	}
	python_foreach_impl configuration
}

src_compile() {
	compilation() {
		cd "${BUILD_DIR}" || die
		default
	}
	python_foreach_impl compilation

	if use doc; then
		cd "${S}"/../sphinx || die
		emake
	fi
}

src_install() {
	installation() {
		cd "${BUILD_DIR}" || die
		emake DESTDIR="${D}" install
	}
	python_foreach_impl installation

	cd "${S}"/.. || die

	dodoc ANNOUNCEMENT-${PV} README

	use doc && dodoc -r sphinx/build/.
	if use examples; then
		docinto examples
		dodoc -r qt4examples/.
	fi
}

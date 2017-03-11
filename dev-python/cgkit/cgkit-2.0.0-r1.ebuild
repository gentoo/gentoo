# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1 scons-utils toolchain-funcs

MY_P="${P/_/}"

DESCRIPTION="Python library for creating 3D images"
HOMEPAGE="http://cgkit.sourceforge.net"
SRC_URI="
	$(python_gen_cond_dep mirror://sourceforge/${PN}/${PN}/${P}/${P}-py2k.tar.gz 'python2*')
	$(python_gen_cond_dep mirror://sourceforge/${PN}/${PN}/${P}/${P}-py3k.tar.gz 'python3*')"

LICENSE="LGPL-2.1 MPL-1.1 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="3ds"

RDEPEND="
	>=dev-libs/boost-1.48[python,${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/pyprotocols[${PYTHON_USEDEP}]' 'python2*')
	dev-python/pyopengl[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	3ds? ( ~media-libs/lib3ds-1.3.0 )"
DEPEND="${RDEPEND}"

src_unpack() {
	cgkit_unpack() {
		local tarball
		if python_is_python3; then
			tarball=${P}-py3k.tar.gz
		else
			tarball=${P}-py2k.tar.gz
		fi
		mkdir "${BUILD_DIR}" || die
		tar -C "${BUILD_DIR}" -x --strip-components 1 -f "${DISTDIR}/${tarball}" || die
	}
	python_foreach_impl cgkit_unpack
	mkdir "${S}" || die
}

python_prepare() {
	eapply \
		"${FILESDIR}"/${PN}-2.0.0-fix-build-system.patch \
		"${FILESDIR}"/${PN}-2.0.0-fix-c++14.patch
	if python_is_python3; then
		eapply "${FILESDIR}"/${PN}-py3k-pillow.patch
	else
		eapply "${FILESDIR}"/${PN}-py2k-pillow.patch
	fi

	cp config_template.cfg config.cfg || die
	cat >> config.cfg <<- _EOF_ || die
		BOOST_LIB = 'boost_python-${EPYTHON#python}'
		LIBS += ['GL', 'GLU', 'glut']
		LIB3DS_AVAILABLE = $(usex 3ds True False)
	_EOF_

	# Remove invalid test
	rm -f unittests/test_pointcloud.py || die
}

python_configure_all() {
	tc-export AR CXX
}

python_compile() {
	pushd supportlib >/dev/null || die
	CXXFLAGS="${CXXFLAGS} -fPIC" escons
	popd >/dev/null || die
	distutils-r1_python_compile
}

python_test() {
	pushd unittests >/dev/null || die
	mkdir tmp || die
	"${EPYTHON}" all.py || die "Testing failed with ${EPYTHON}"
	popd >/dev/null || die
}

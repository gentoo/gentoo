# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1 eutils scons-utils toolchain-funcs

MY_P="${P/_/}"

DESCRIPTION="Python library for creating 3D images"
HOMEPAGE="http://cgkit.sourceforge.net"
SRC_URI="$(python_gen_cond_dep mirror://sourceforge/${PN}/${PN}/${P}/${P}-py2k.tar.gz 'python2*')
	$(python_gen_cond_dep mirror://sourceforge/${PN}/${PN}/${P}/${P}-py3k.tar.gz 'python3*')"

LICENSE="LGPL-2.1 MPL-1.1 GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="3ds"

RDEPEND=">=dev-libs/boost-1.48[python,${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/pyprotocols[${PYTHON_USEDEP}]' 'python2*')
	dev-python/pyopengl[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	3ds? ( ~media-libs/lib3ds-1.3.0 )"
DEPEND="${RDEPEND}
	dev-util/scons"

DISTUTILS_IN_SOURCE_BUILD=1

cgkit_unpack() {
	local tarball
	if [[ ${EPYTHON} == python3* ]]; then
		tarball=${P}-py3k.tar.gz
	else
		tarball=${P}-py2k.tar.gz
	fi
	mkdir "${BUILD_DIR}" || die
	tar -C "${BUILD_DIR}" -x --strip-components 1 -f "${DISTDIR}/${tarball}" || die
}

src_unpack() {
	python_foreach_impl cgkit_unpack
	mkdir "${S}" || die
}

python_prepare_all() {
	return 0
}

python_prepare() {
	if [[ ${EPYTHON} == python3* ]]; then
		epatch "${FILESDIR}/${PN}-py3k-pillow.patch"
	else
		epatch "${FILESDIR}/${PN}-py2k-pillow.patch"
	fi
	[[ ${PATCHES} ]] && epatch "${PATCHES[@]}"

	sed -e "s/fPIC/fPIC\",\"${CFLAGS// /\",\"}/" -i supportlib/SConstruct
	cp config_template.cfg config.cfg
	echo "BOOST_LIB = 'boost_python-${EPYTHON#python}'" >> config.cfg
	echo "LIBS += ['GL', 'GLU', 'glut']" >> config.cfg
	if use 3ds; then
		echo "LIB3DS_AVAILABLE = True" >> config.cfg
	fi

	sed -e "s:INC_DIRS = \[\]:INC_DIRS = \['/usr/include'\]:" -i setup.py

	# Remove invalid test
	rm -f unittests/test_pointcloud.py || die
}

python_compile() {
	pushd supportlib > /dev/null || die
	escons
	popd > /dev/null || die
	distutils-r1_python_compile
}

python_test() {
	pushd unittests > /dev/null || die
	mkdir tmp || die
	"${PYTHON}" all.py || die "Testing failed with ${EPYTHON}"
	popd > /dev/null || die
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads"
DISTUTILS_OPTIONAL=true
AUTOTOOLS_AUTORECONF=true

inherit autotools-utils multilib distutils-r1 versionator

MY_PV=$(replace_all_version_separators '_' )
S=${WORKDIR}/libtorrent-libtorrent-${MY_PV}

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="http://libtorrent.org"
SRC_URI="https://github.com/arvidn/libtorrent/archive/libtorrent-${MY_PV}.tar.gz -> rb_libtorrent-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc examples python ssl static-libs test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/boost-1.53:=[threads]
	sys-libs/zlib
	examples? ( !net-p2p/mldonkey )
	ssl? ( dev-libs/openssl:0= )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:=[python,${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2"

RESTRICT="test"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	chmod a-x docs/*.rst docs/*.htm* src/*.cpp include/libtorrent/*.hpp || die
	./autotool.sh
}

src_configure() {
	if use python_targets_python3_4 ;then
		boost_py3="--with-boost-python=3.4"
	elif use python_targets_python3_5 ;then
		boost_py3="--with-boost-python=3.5"
	else
		boost_py3=""
	fi

	if use python_targets_python2_7 ;then
		boost_py2="--with-boost-python=2.7"
	else
		boost_py2=""
	fi

	local myeconfargs=(
		--disable-silent-rules # bug 441842
		--with-boost-system=mt
		$(use_enable debug)
		$(use_enable test tests)
		$(use_enable examples)
		$(use_enable ssl encryption)
		$(use_enable python python-binding)
		$(usex debug "--enable-logging=verbose" "")
		${boost_py3}
		${boost_py2}
	)

	if use python ;then
		python_setup
	fi

	autotools-utils_src_configure

	if use python ;then
		cd "${BUILD_DIR}"/bindings/python || die && \
		distutils-r1_src_configure
	fi
}

src_compile() {
	autotools-utils_src_compile

	if use python ;then
		cd "${BUILD_DIR}"/bindings/python || die && \
		distutils-r1_src_compile
	fi
}

src_install() {
	if use doc ;then
		HTML_DOCS=( "${S}"/docs/. )
	fi

	autotools-utils_src_install

	if use python ;then
		cd "${BUILD_DIR}"/bindings/python || die && \
		distutils-r1_src_install
	fi
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/libopensync/libopensync-9999.ebuild,v 1.10 2012/05/03 20:21:00 jdhore Exp $

EAPI="3"

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit cmake-utils subversion python

DESCRIPTION="OpenSync synchronisation framework library"
HOMEPAGE="http://www.opensync.org/"
SRC_URI=""

ESVN_REPO_URI="http://svn.opensync.org/trunk"

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
SLOT="0"
LICENSE="LGPL-2.1"
IUSE="debug doc python" # test

RDEPEND="dev-db/sqlite:3
	>=dev-libs/glib-2.12:2
	dev-libs/libxml2
	dev-libs/libxslt"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc?	( app-doc/doxygen
			  media-gfx/graphviz )
	python? ( >=dev-lang/swig-1.3.17 )"
#	test? ( >=dev-libs/check-0.9.2 )

DOCS="AUTHORS CODING ChangeLog README"

# tests don't pass
RESTRICT="test"

src_prepare() {
	# Use cmake's instead - bug #276220
	rm "${S}"/cmake/modules/FindPythonLibs.cmake

	use python && python_copy_sources
}

src_configure() {
	local mycmakeargs="-DCMAKE_SKIP_RPATH=ON
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use_enable python WRAPPER)
		$(cmake-utils_use python OPENSYNC_PYTHONBINDINGS)
		$(cmake-utils_use debug OPENSYNC_DEBUG_MODULES)
		$(cmake-utils_use debug OPENSYNC_TRACE)"
#		$(cmake-utils_use test OPENSYNC_UNITTESTS)

	do_configure() {
		if use python; then
			CMAKE_BUILD_DIR="${WORKDIR}/${P}-${PYTHON_ABI}"
			CMAKE_USE_DIR="${CMAKE_BUILD_DIR}"
			# since we're using cmake's FindPythonLibs PYTHON_VERSION is not defined
			sed -i -e "s:\${PYTHON_VERSION}:${PYTHON_ABI}:g" \
				"${CMAKE_BUILD_DIR}"/wrapper/CMakeLists.txt
		fi
		cmake-utils_src_configure || die
	}

	use python \
		&& python_execute_function -s do_configure \
		|| do_configure
}

src_compile() {
	do_compile() {
		if use python; then
			CMAKE_BUILD_DIR="${WORKDIR}/${P}-${PYTHON_ABI}"
			CMAKE_USE_DIR="${CMAKE_BUILD_DIR}"
		fi
		cmake-utils_src_compile || die
	}

	use python \
		&& python_execute_function -s do_compile \
		|| do_compile

	if use doc ; then
		cmake-utils_src_make DoxygenDoc || die
	fi
}

src_test() {
	pushd "${CMAKE_BUILD_DIR}" > /dev/null

	if ! LD_LIBRARY_PATH="${CMAKE_BUILD_DIR}/opensync/" emake -j1 test ; then
		die "Make test failed. See above for details."
	fi

	popd > /dev/null
}

src_install() {
	do_install() {
		if use python; then
			CMAKE_BUILD_DIR="${WORKDIR}/${P}-${PYTHON_ABI}"
			CMAKE_USE_DIR="${CMAKE_BUILD_DIR}"
		fi
		cmake-utils_src_install || die
	}

	use python \
		&& python_execute_function -s do_install \
		|| do_install

	find "${D}" -name '*.la' -exec rm -f {} + || die

	if use doc; then
		cd "${CMAKE_BUILD_DIR}"
		dohtml docs/html/* || die
	fi
}

pkg_postinst() {
	elog "Building with 'debug' useflag is highly encouraged"
	elog "and requiered for bug reports."
	elog "Also see http://www.opensync.org/wiki/tracing"
}

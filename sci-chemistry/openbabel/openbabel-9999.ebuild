# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
WX_GTK_VER=3.2-gtk3

inherit cmake desktop flag-o-matic perl-functions python-r1 toolchain-funcs wxwidgets xdg-utils

DESCRIPTION="Interconverts file formats used in molecular modeling"
HOMEPAGE="https://openbabel.org/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openbabel/${PN}.git"
else
	if [[ "${PV}" == *_p* ]]; then	# eg., openbabel-3.1.1_p20210325
		# Set to commit hash
		OPENBABEL_COMMIT=
		SRC_URI="https://github.com/${PN}/${PN}/archive/${OPENBABEL_COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${OPENBABEL_COMMIT}"
	else
		MY_P="${PN}-$(ver_rs 1- -)"
		SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${MY_P}"
	fi
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

SRC_URI="${SRC_URI}
	https://openbabel.org/docs/dev/_static/babel130.png -> ${PN}.png
	https://openbabel.org/OBTitle.jpg ->  ${PN}.jpg"

# See src/CMakeLists.txt for LIBRARY_VERSION
SLOT="0/7.0.0"
LICENSE="GPL-2"
IUSE="cpu_flags_arm_neon cpu_flags_x86_sse2 cpu_flags_x86_sse4_2 doc examples +inchi json minimal openmp perl png python test wxwidgets"

RESTRICT="!test? ( test )"

# Inaccurate dependency logic upstream
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( inchi json !minimal wxwidgets )
"

BDEPEND="
	dev-lang/perl
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-latex
	)
	perl? ( >=dev-lang/swig-2 )
	python? ( >=dev-lang/swig-2 )
	test? ( dev-lang/python )
"

COMMON_DEPEND="
	dev-cpp/eigen:3
	dev-libs/libxml2:2
	sys-libs/zlib:=
	inchi? ( sci-libs/inchi )
	json? ( >=dev-libs/rapidjson-1.1.0 )
	png? ( x11-libs/cairo )
	python? ( ${PYTHON_DEPS} )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
"

DEPEND="
	${COMMON_DEPEND}
	perl? ( dev-lang/perl )
"

RDEPEND="
	${COMMON_DEPEND}
	perl? (
		dev-lang/perl:=
		!sci-chemistry/openbabel-perl
	)
"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

prepare_python_bindings() {
	mkdir -p scripts/${EPYTHON} || die
	# Appends to scripts/CMakeLists.txt, substituting the correct tags, for
	# each valid python implementation,
	cat "${FILESDIR}"/${PN}-python.cmake | \
		sed -e "s|@@EPYTHON@@|${EPYTHON}|" \
			-e "s|@@PYTHON_INCUDE_DIR@@|$(python_get_includedir)|" \
			-e "s|@@PYTHON_LIBS@@|$(python_get_LIBS)|" \
			-e "s|@@PYTHON_SITEDIR@@|$(python_get_sitedir)|" >> \
				scripts/CMakeLists.txt || die
}

src_prepare() {
	cmake_src_prepare

	if use perl; then
		perl_set_version

		sed -e "/\${LIB_INSTALL_DIR}\/auto/s|\${LIB_INSTALL_DIR}|${VENDOR_ARCH}|" \
			-e "/\${LIB_INSTALL_DIR}\/Chemistry/s|\${LIB_INSTALL_DIR}|${VENDOR_ARCH}|" \
			-i scripts/CMakeLists.txt || die
	fi

	if use python; then
		# Skip the python bindings sections as we'll append our own
		sed -e '/^if (PYTHON_BINDINGS)$/s|PYTHON_BINDINGS|false|' \
			-i {scripts,test}/CMakeLists.txt || die
		if use test; then
			# Problems with testbindings built with -O2
			local test_skip="@unittest.skip('Similar to Issue #2138')"
			sed -e "/def testTemplates/s|^|    ${test_skip}\\n|" \
				-i test/testbindings.py || die
			test_skip="@unittest.skip('Similar to Issue #2246')"
			sed -e "/^def test_write_string/s|^|${test_skip}\\n|" \
				-i test/testobconv_writers.py || die
			fi
		python_foreach_impl prepare_python_bindings
	fi

	# Remove dependency automagic
	if ! use png; then
		sed -e '/^find_package(Cairo/d' -i CMakeLists.txt || die
	fi
	if ! use wxwidgets; then
		sed -e '/^find_package(wxWidgets/d' -i CMakeLists.txt || die
	fi
	if ! use inchi; then
		sed -e '/^else()$/s|else\(\)|elseif\(false\)|' \
			-i cmake/modules/FindInchi.cmake || die
	fi

	# Don't install example bins to /usr/bin
	if use examples; then
		sed -e "/RUNTIME DESTINATION/s|bin|share/doc/${PF}/examples|" \
			-i doc/examples/CMakeLists.txt || die
	fi

	# boost is only used if building with gcc-3.x, which isn't supported in
	# Gentoo. Still, it shouldn't look for, and include, its headers
	sed -e '/find_package(Boost/d' -i {{tools,src}/,}CMakeLists.txt || die
}

src_configure() {
	if use json; then
		# -DOPTIMIZE_NATIVE=ON also forces -march=native so use
		# cpu_flags to set defines instead
		use cpu_flags_x86_sse2 && append-cppflags -DRAPIDJSON_SSE2
		use cpu_flags_x86_sse4_2 && append-cppflags -DRAPIDJSON_SSE42
		use cpu_flags_arm_neon && append-cppflags -DRAPIDJSON_NEON
	fi

	use wxwidgets && setup-wxwidgets

	use_bindings() {
		(use perl || use python) && (echo 'yes' || die) || (echo 'no' || die)
	}

	local mycmakeargs=(
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_GUI=$(usex wxwidgets)
		-DENABLE_OPENMP=$(usex openmp)
		-DENABLE_TESTS=$(usex test)
		-DMINIMAL_BUILD=$(usex minimal)
		# Set this, otherwise it defaults to true and forces WITH_INCHI=true
		-DOPENBABEL_USE_SYSTEM_INCHI=$(usex inchi)
		-DOPTIMIZE_NATIVE=OFF
		-DPERL_BINDINGS=$(usex perl)
		-DPYTHON_BINDINGS=$(usex python)
		-DRUN_SWIG=$(use_bindings)
		-DWITH_COORDGEN=false
		-DWITH_INCHI=$(usex inchi)
		-DWITH_JSON=$(usex json)
		-DWITH_MAEPARSER=false
	)

	if use test; then
		# Help cmake find the python interpreter when dev-lang/python-exec is built
		# without native-symlinks support.
		python_setup
		mycmakeargs+=( -DPYTHON_EXECUTABLE="${PYTHON}" )
	fi

	cmake_src_configure
}

src_test() {
	# Wierd deadlock causes system_load to keep rising
	cmake_src_test -j1
}

openbabel-optimize() {
	python_optimize "${D}/$(python_get_sitedir)"/openbabel || die
}

src_install() {
	cmake_src_install

	docinto html
	for x in doc/*.html; do
		[[ ${x} != doc/api*.html ]] && dodoc ${x}
	done
	# Rendered in some html pages
	newdoc "${DISTDIR}"/${PN}.png babel130.png
	newdoc "${DISTDIR}"/${PN}.jpg OBTitle.jpg

	if use doc; then
		cmake_src_install docs
		docinto html/API
		dodoc -r doc/API/html/.
	fi

	if use examples; then
		# no compression since we want ready-to-run scripts
		docompress -x /usr/share/doc/${PF}/examples

		# ${PV} doesn't correspond to the internal BABEL_VERSION for
		# live or patch release builds so we grep it
		local babel_ver=$(
			grep '^#define BABEL_VERSION' < \
				"${BUILD_DIR}"/include/openbabel/babelconfig.h | \
				cut -d \" -f 2 || die
		)
		docinto examples/povray
		dodoc doc/dioxin.* doc/README*.pov*
		# Needed by the povray example
		dosym ../../../../${PN}/${babel_ver}/babel_povray3.inc \
			/usr/share/doc/${PF}/examples/povray/babel31.inc

	fi

	if use perl; then
		docinto /
		newdoc scripts/perl/Changes Changes.perl
		newdoc scripts/perl/README README.perl
		if use examples; then
			docinto examples/perl
			dodoc -r scripts/perl/examples/.
		fi
	fi

	if use python; then
		python_foreach_impl openbabel-optimize
		docinto /
		newdoc scripts/python/README.rst README.python.rst
		docinto html
		dodoc scripts/python/*.html
		if use examples; then
			docinto examples/python
			dodoc -r scripts/python/examples/.
		fi
	fi

	if use wxwidgets; then
		make_desktop_entry obgui "Open Babel" ${PN}
		doicon "${DISTDIR}"/${PN}.png
	fi
}

pkg_postinst() {
	use wxwidgets && xdg_desktop_database_update
}

pkg_postrm() {
	use wxwidgets && xdg_desktop_database_update
}

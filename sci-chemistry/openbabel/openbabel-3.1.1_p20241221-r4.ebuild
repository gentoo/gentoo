# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENTOO_DEPEND_ON_PERL="no"
PYTHON_COMPAT=( python3_{11..14} )
WX_GTK_VER=3.2-gtk3

inherit cmake desktop flag-o-matic perl-module python-r1 toolchain-funcs wxwidgets xdg

DESCRIPTION="Interconverts file formats used in molecular modeling"
HOMEPAGE="https://openbabel.org/ https://github.com/openbabel/openbabel/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openbabel/${PN}.git"
else
	if [[ "${PV}" == *_p* ]]; then	# eg., openbabel-3.1.1_p20210325
		# Set to commit hash
		OPENBABEL_COMMIT="889c350feb179b43aa43985799910149d4eaa2bc"
		SRC_URI="https://github.com/${PN}/${PN}/archive/${OPENBABEL_COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${OPENBABEL_COMMIT}"
	else
		MY_P="${PN}-$(ver_rs 1- -)"
		SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${MY_P}"
	fi
	KEYWORDS="amd64 ~arm ~x86"
fi

LICENSE="GPL-2"
# See src/CMakeLists.txt for LIBRARY_VERSION
SLOT="0/7.0.0"
IUSE="cpu_flags_arm_neon cpu_flags_x86_sse2 cpu_flags_x86_sse4_2 doc examples +inchi json minimal openmp perl png python test wxwidgets ${GENTOO_PERL_USESTRING}"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( inchi !minimal python? ( json png ) ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	dev-cpp/eigen:3
	virtual/zlib:=
	inchi? ( sci-libs/inchi )
	json? ( >=dev-libs/rapidjson-1.1.0 )
	!minimal? (
		dev-libs/libxml2:2=
		png? ( x11-libs/cairo )
	)
	perl? (
		${GENTOO_PERL_DEPSTRING}
		dev-lang/perl:=
	)
	python? ( ${PYTHON_DEPS} )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}=[X] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	doc? (
		app-text/doxygen
		dev-texlive/texlive-latex
	)
	perl? ( dev-lang/swig )
	python? ( dev-lang/swig )
	test? ( dev-lang/python )
"

PATCHES=(
	# Set include dir only for global implementation
	"${FILESDIR}"/${PN}-3.1.1_p2024-fix_pybind.patch
	# prevent installation of examples in /usr/bin
	"${FILESDIR}"/${PN}-3.1.1_p2024-fix_examples.patch
	# cmake4-compat
	"${FILESDIR}"/${PN}-3.1.1_p2024-cmake4.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

gen_python_bindings() {
	mkdir -p scripts/${EPYTHON} || die
	# Appends to scripts/CMakeLists.txt, substituting the correct tags, for
	# each valid python implementation,
	cat "${FILESDIR}"/${PN}-python-r2.cmake | \
		sed -e "s|@@EPYTHON@@|${EPYTHON}|" \
			-e "s|@@PYTHON_INCLUDE_DIR@@|$(python_get_includedir)|" \
			-e "s|@@PYTHON_LIBS@@|$(python_get_LIBS)|" \
			-e "s|@@PYTHON_SITEDIR@@|$(python_get_sitedir)|" >> \
				scripts/CMakeLists.txt || die
}

src_prepare() {
	cmake_src_prepare

	# Prevent bundled inchi as fallback
	rm -r include/inchi || die

	use python && python_foreach_impl gen_python_bindings
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
		$(cmake_use_find_package png Cairo)
		$(cmake_use_find_package wxwidgets wxWidgets)
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_GUI=$(usex wxwidgets)
		-DENABLE_OPENMP=$(usex openmp)
		-DENABLE_TESTS=$(usex test)
		-DMINIMAL_BUILD=$(usex minimal)
		# All three required to comply w/ useflag and prevent bundled lib
		-DOPENBABEL_USE_SYSTEM_INCHI=$(usex inchi)
		-DADD_INCHI_FORMAT=$(usex inchi)
		-DWITH_INCHI=$(usex inchi)
		-DOPTIMIZE_NATIVE=OFF
		-DPERL_BINDINGS=$(usex perl)
		-DPYTHON_BINDINGS=$(usex python)
		-DRUN_SWIG=$(use_bindings)
		-DWITH_COORDGEN=false
		-DWITH_JSON=$(usex json)
		# MEAPARSER
		-DCMAKE_DISABLE_FIND_PACKAGE_Boost=ON
		-DWITH_MAEPARSER=false
	)

	if use perl; then
		perl_set_version
		mycmakeargs+=(
			-DPERL_INSTDIR="${VENDOR_ARCH}"
		)
	fi

	if use test; then
		# Help cmake find the python interpreter when dev-lang/python-exec is built
		# without native-symlinks support.
		python_setup
		mycmakeargs+=(
			-DPYTHON_EXECUTABLE="${PYTHON}"
		)
	fi

	cmake_src_configure
}

src_compile() {
	# Avoid perl-module_src_compile (bug #963096)
	cmake_src_compile
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# https://github.com/openbabel/openbabel/issues/2766
		test_align_{4,5}
	)
	! use wxwidgets && CMAKE_SKIP_TESTS+=(
		test_tautomer_{22,27}
	)

	# Weird deadlock causes system_load to keep rising
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
		make_desktop_entry --eapi9 obgui -n "Open Babel" -i ${PN}
		newicon "${S}"/src/GUI/babel.xpm ${PN}.xpm
	fi
}

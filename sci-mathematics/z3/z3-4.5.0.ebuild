# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit flag-o-matic java-pkg-2 java-pkg-simple python-r1 toolchain-funcs

DESCRIPTION="An efficient theorem prover"
HOMEPAGE="http://z3.codeplex.com/"
SRC_URI="https://github.com/Z3Prover/z3/archive/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples gmp isabelle java python"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	gmp? ( dev-libs/gmp:0 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	java? ( >=virtual/jdk-1.8 )"

S=${WORKDIR}/${PN}-${P}
JAVA_SRC_DIR=${S}/src/api/java

SO1="0"
SO2="1"
SOVER="${SO1}.${SO2}"

pkg_setup() {
	python_setup

	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(tc-getCXX)$ == *g++* ]] && ! tc-has-openmp; then
			ewarn "Please use an openmp compatible compiler"
			ewarn "like >gcc-4.2 with USE=openmp"
			die "Openmp support missing in compiler"
		fi
	fi
}

src_prepare() {
	default

	sed \
		-e 's:-O3::g' \
		-e 's:-fomit-frame-pointer::' \
		-e 's:-msse2::g' \
		-e 's:-msse::g' \
		-e "/LINK_EXTRA_FLAGS/s:@LDFLAGS@:-lrt $(usex gmp -lgmp ""):g" \
		-e 's:t@\$:t\$:g' \
		-i scripts/*mk* || die

	sed \
		-e "s:SLIBEXTRAFLAGS = '':SLIBEXTRAFLAGS = '-Wl,-soname,lib${PN}.so.${SOVER}':" \
		-i scripts/mk_util.py || die

	sed -e 's:api\\html\\ml:api/html/ml:' \
		-e 's:python/z3.py:python/z3/z3.py:' \
		-i doc/mk_api_doc.py || die

	append-ldflags -fopenmp
}

src_configure() {
	local PYTHON_SITEDIR
	python_export PYTHON_SITEDIR
	export Z3_INSTALL_LIB_DIR="$(get_libdir)"
	export Z3_INSTALL_INCLUDE_DIR="include/z3"
	set -- \
		--pypkgdir="${PYTHON_SITEDIR}/${PN}" \
		--prefix="${ROOT}usr" \
		$(usex gmp --gmp "") \
		$(usex python --python "") \
		$(usex java --java "")
	echo ./configure "$@" >&2
	# LANG=C to force external tools to output ascii text only
	# otherwise configure crashes as:
	#    File "scripts/mk_make.py", line 21, in <module>
	#    UnicodeEncodeError: 'ascii' codec can't encode characters in position 80-82: ordinal not in range(128)
	LANG=C ./configure "$@" || die
	echo ${EPYTHON} scripts/mk_make.py "$@" >&2
	LANG=C ${EPYTHON} scripts/mk_make.py || die
}

src_compile() {
	emake \
		--directory="build" \
		CXX=$(tc-getCXX) \
		LINK="$(tc-getCXX) ${LDFLAGS}" \
		LINK_FLAGS="${LDFLAGS}"

	use java && java-pkg-simple_src_compile

	if use doc; then
		pushd doc || die
		${EPYTHON} mk_api_doc.py || die
		popd || die
	fi
}

src_install() {
	emake \
		--directory="build" \
		CXX=$(tc-getCXX) \
		LINK="$(tc-getCXX) ${LDFLAGS}" \
		LINK_FLAGS="${LDFLAGS}" \
		install DESTDIR="${D}"

	dosym "/usr/$(get_libdir)/lib${PN}.so" \
		  "/usr/$(get_libdir)/lib${PN}.so.${SO1}" \
		  || die "Could not create /usr/$(get_libdir)/lib${PN}.so.${SO1} symlink"
	dosym "/usr/$(get_libdir)/lib${PN}.so" \
		  "/usr/$(get_libdir)/lib${PN}.so.${SOVER}" \
		  || die "Could not create libz3.so soname symlink"

	if use examples; then
		insinto /usr/share/${PN}
		doins -r examples
	fi

	if use python; then
		python_moduleinto "${PN}"
		instpybind() {
			python_domodule src/api/python/z3/*.py
			dosym "/usr/$(get_libdir)/lib${PN}.so" \
				  "$(python_get_sitedir)/${PN}/lib${PN}.so" \
				|| die "Could not create $(python_get_sitedir)/lib${PN}.so symlink for python module"
		}
		python_foreach_impl instpybind
	fi

	use java && java-pkg-simple_src_install

	if use isabelle; then
		ISABELLE_HOME="${ROOT}usr/share/Isabelle"
		dodir "${ISABELLE_HOME}/contrib/${PN}-${PV}/etc"
		cat <<- EOF >> "${S}/settings" || die
			Z3_COMPONENT="\$COMPONENT"
			Z3_HOME="${ROOT}usr/bin"
			Z3_SOLVER="${ROOT}usr/bin/z3"
			Z3_REMOTE_SOLVER="z3"
			Z3_VERSION="${PV}"
			Z3_INSTALLED="yes"
			Z3_NON_COMMERCIAL="yes"
		EOF
		insinto "${ISABELLE_HOME}/contrib/${PN}-${PV}/etc"
		doins "${S}/settings"
	fi

	local DOCS=( "README.md" "RELEASE_NOTES" )
	local HTML_DOCS=( "doc/api/html/." )
	use doc && einstalldocs
}

pkg_postinst() {
	if use isabelle; then
		if [ -f "${ROOT}etc/isabelle/components" ]; then
			if egrep "contrib/${PN}-[0-9.]*" "${ROOT}etc/isabelle/components"; then
				sed -e "/contrib\/${PN}-[0-9.]*/d" \
					-i "${ROOT}etc/isabelle/components"
			fi
			cat <<- EOF >> "${ROOT}etc/isabelle/components"
				contrib/${PN}-${PV}
			EOF
		fi
	fi
}

pkg_postrm() {
	if use isabelle; then
		if [ ! -f "${ROOT}usr/bin/Z3" ]; then
			if [ -f "${ROOT}etc/isabelle/components" ]; then
				# Note: this sed should only match the version of this ebuild
				# Which is what we want as we do not want to remove the line
				# of a new Isabelle component being installed during an upgrade.
				sed -e "/contrib\/${PN}-${PV}/d" \
					-i "${ROOT}etc/isabelle/components"
			fi
		fi
	fi
}

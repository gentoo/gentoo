# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1 toolchain-funcs

DESCRIPTION="An efficient theorem prover"
HOMEPAGE="http://z3.codeplex.com/"
SRC_URI="https://github.com/Z3Prover/z3/archive/${P}.tar.gz"

SLOT="0/4.8"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples gmp isabelle java openmp python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	gmp? ( dev-libs/gmp:0= )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	java? ( >=virtual/jdk-1.8 )"

S=${WORKDIR}/${PN}-${P}

CMAKE_BUILD_TYPE=RelWithDebInfo

pkg_setup() {
	python_setup

	if [[ ${MERGE_TYPE} != binary ]]; then
		if use openmp && ! tc-has-openmp; then
			ewarn "Please use an openmp compatible compiler"
			ewarn "like >gcc-4.2 with USE=openmp"
			die "Openmp support missing in compiler"
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${P}"
		-DUSE_LIB_GMP=$(usex gmp)
		-DUSE_OPENMP=$(usex openmp)
		-DENABLE_EXAMPLE_TARGETS=OFF
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_PYTHON_BINDINGS=$(usex python)
		-DBUILD_JAVA_BINDINGS=$(usex java)
	)

	cmake-utils_src_configure
}

src_install() {
	local DOCS=( "README.md" "RELEASE_NOTES" )
	cmake-utils_src_install

	use examples && dodoc -r examples
	use python && python_optimize

	if use isabelle; then
		insinto /usr/share/Isabelle/contrib/${P}/etc
		newins - settings <<-EOF
			Z3_COMPONENT="\$COMPONENT"
			Z3_HOME="${EPREFIX}/usr/bin"
			Z3_SOLVER="${EPREFIX}/usr/bin/z3"
			Z3_REMOTE_SOLVER="z3"
			Z3_VERSION="${PV}"
			Z3_INSTALLED="yes"
			Z3_NON_COMMERCIAL="yes"
		EOF
	fi
}

pkg_postinst() {
	if use isabelle; then
		if [[ -f ${ROOT%/}/etc/isabelle/components ]]; then
			sed -e "/contrib\/${PN}-[0-9.]*/d" \
				-i "${ROOT%/}/etc/isabelle/components" || die
			cat <<-EOF >> "${ROOT%/}/etc/isabelle/components" || die
				contrib/${P}
			EOF
		fi
	fi
}

pkg_postrm() {
	if use isabelle; then
		if [[ ! ${REPLACING_VERSIONS} ]]; then
			if [[ -f "${ROOT%/}/etc/isabelle/components" ]]; then
				# Note: this sed should only match the version of this ebuild
				# Which is what we want as we do not want to remove the line
				# of a new Isabelle component being installed during an upgrade.
				sed -e "/contrib\/${P}/d" \
					-i "${ROOT%/}/etc/isabelle/components" || die
			fi
		fi
	fi
}

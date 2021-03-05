# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{7..9} )

inherit cmake-multilib python-single-r1 toolchain-funcs

DESCRIPTION="An efficient theorem prover"
HOMEPAGE="https://github.com/Z3Prover/z3/"
SRC_URI="https://github.com/Z3Prover/z3/archive/${P}.tar.gz"
S=${WORKDIR}/z3-${P}

SLOT="0/4.8"
LICENSE="MIT"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
IUSE="doc examples gmp isabelle java python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	gmp? ( dev-libs/gmp:0=[cxx,${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	java? ( >=virtual/jdk-1.8 )"
BDEPEND="
	doc? ( app-doc/doxygen )"

CMAKE_BUILD_TYPE=RelWithDebInfo

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${P}"
		-DZ3_USE_LIB_GMP=$(usex gmp)
		-DZ3_ENABLE_EXAMPLE_TARGETS=OFF
		-DZ3_BUILD_DOCUMENTATION=$(multilib_native_usex doc)
		-DZ3_BUILD_PYTHON_BINDINGS=$(multilib_native_usex python)
		-DZ3_BUILD_JAVA_BINDINGS=$(multilib_native_usex java)
		-DZ3_INCLUDE_GIT_DESCRIBE=OFF
		-DZ3_INCLUDE_GIT_HASH=OFF
	)

	cmake_src_configure
}

multilib_src_test() {
	cmake_build test-z3
	set -- "${BUILD_DIR}"/test-z3 /a
	echo "${@}" >&2
	"${@}" || die
}

multilib_src_install_all() {
	dodoc README.md RELEASE_NOTES
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
		if [[ -f ${ROOT}/etc/isabelle/components ]]; then
			sed -e "/contrib\/${PN}-[0-9.]*/d" \
				-i "${ROOT}/etc/isabelle/components" || die
			cat <<-EOF >> "${ROOT}/etc/isabelle/components" || die
				contrib/${P}
			EOF
		fi
	fi
}

pkg_postrm() {
	if use isabelle; then
		if [[ ! ${REPLACING_VERSIONS} ]]; then
			if [[ -f "${ROOT}/etc/isabelle/components" ]]; then
				# Note: this sed should only match the version of this ebuild
				# Which is what we want as we do not want to remove the line
				# of a new Isabelle component being installed during an upgrade.
				sed -e "/contrib\/${P}/d" \
					-i "${ROOT}/etc/isabelle/components" || die
			fi
		fi
	fi
}

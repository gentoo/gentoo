# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/pdb2pqr/pdb2pqr-1.9.0-r1.ebuild,v 1.7 2015/08/07 10:36:03 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit scons-utils fortran-2 flag-o-matic python-r1 toolchain-funcs

DESCRIPTION="An automated pipeline for performing Poisson-Boltzmann electrostatics calculations"
HOMEPAGE="http://www.poissonboltzmann.org/"
SRC_URI="https://github.com/Electrostatics/apbs-${PN}/releases/download/${P}/${PN}-src-${PV}.tar.gz"

SLOT="0"
LICENSE="BSD"
IUSE="doc examples opal +pdb2pka"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-chemistry/openbabel-python[${PYTHON_USEDEP}]
	opal? ( dev-python/zsi[${PYTHON_USEDEP}] )
	pdb2pka? ( sci-chemistry/apbs[${PYTHON_USEDEP},-mpi] )"
DEPEND="${RDEPEND}
	dev-lang/swig:0"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-install-py.patch
)

pkg_setup() {
	if [[ -z ${MAXATOMS} ]]; then
		einfo "If you like to have support for more then 10000 atoms,"
		einfo "export MAXATOMS=\"your value\""
		export MAXATOMS=10000
	else
		einfo "Allow usage of ${MAXATOMS} during calculations"
	fi
	fortran-2_pkg_setup
}

src_prepare() {
	find -type f \( -name "*\.pyc" -o -name "*\.pyo" \) -delete || die

	export CXXFLAGS="${CXXFLAGS}"
	export LDFLAGS="${LDFLAGS}"

	epatch ${PATCHES[@]}
	tc-export CXX
	rm -rf scons || die

	python_copy_sources
}

src_configure() {
	python_configure() {
		cd "${BUILD_DIR}" || die

		cat > build_config.py <<- EOF
		PREFIX="${D}/$(python_get_sitedir)/${PN}"
		#URL="http://<COMPUTER NAME>/pdb2pqr/"
		APBS="${EPREFIX}/usr/bin/apbs"
		#OPAL="http://nbcr-222.ucsd.edu/opal2/services/pdb2pqr_1.8"
		#APBS_OPAL="http://nbcr-222.ucsd.edu/opal2/services/apbs_1.3"
		MAX_ATOMS=${MAXATOMS}
		BUILD_PDB2PKA=$(usex pdb2pka True False)
		REBUILD_SWIG=True
		EOF
	}

	python_foreach_impl python_configure
}

src_compile() {
	python_compile() {
		cd "${BUILD_DIR}" || die
		escons
	}
	python_foreach_impl python_compile
}

src_test() {
	python_test() {
		local myesconsargs=( -j1 )
		cd "${BUILD_DIR}" || die
		escons test
		escons advtest
		escons complete-test
	}
	python_foreach_impl python_test
}

src_install() {
	dodir /usr/share/doc/${PF}/html
	python_install() {
		local lib

		cd "${BUILD_DIR}" || die

		escons install

		find "${D}$(python_get_sitedir)"/${PN}/{jmol,examples,doc,contrib} -delete || die

		python_doscript "${FILESDIR}"/{${PN},pdb2pka}

		for lib in apbslib.py{,c,o}; do
			dosym ../../apbs/${lib} $(python_get_sitedir)/${PN}/pdb2pka/${lib}
		done
		dosym ../../_apbslib.so $(python_get_sitedir)/${PN}/pdb2pka/_apbslib.so
		python_optimize
	}
	python_foreach_impl python_install

	if use doc; then
		pushd doc > /dev/null
		docinto html
		dodoc -r *.html images pydoc
		popd > /dev/null
	fi

	use examples && \
		insinto /usr/share/${PN}/ && \
		doins -r examples

	dodoc *md NEWS
}

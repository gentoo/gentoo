# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit scons-utils fortran-2 flag-o-matic python-single-r1 toolchain-funcs

DESCRIPTION="Automated pipeline for performing Poisson-Boltzmann electrostatics calculations"
HOMEPAGE="https://www.poissonboltzmann.org/"
SRC_URI="https://github.com/Electrostatics/apbs-${PN}/releases/download/${P}/${PN}-src-${PV}.tar.gz"

SLOT="0"
LICENSE="BSD"
IUSE="doc examples opal +pdb2pka"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		|| (
			dev-python/numpy-python2[${PYTHON_MULTI_USEDEP}]
			dev-python/numpy[${PYTHON_MULTI_USEDEP}]
		)
		sci-chemistry/openbabel-python[${PYTHON_MULTI_USEDEP}]
		opal? ( dev-python/zsi[${PYTHON_MULTI_USEDEP}] )
	')
	pdb2pka? ( sci-chemistry/apbs[${PYTHON_SINGLE_USEDEP},-mpi] )"
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
	python-single-r1_pkg_setup
}

src_prepare() {
	find -type f \( -name "*\.pyc" -o -name "*\.pyo" \) -delete || die

	export CXXFLAGS="${CXXFLAGS}"
	export LDFLAGS="${LDFLAGS}"

	epatch "${PATCHES[@]}"
	tc-export CXX
	rm -rf scons || die
}

src_configure() {
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

src_compile() {
	escons
}

src_test() {
	local myesconsargs=( -j1 )
	escons test
	escons advtest
	escons complete-test
}

src_install() {
	dodir /usr/share/doc/${PF}/html
	local lib

	escons install

	find "${D}$(python_get_sitedir)"/${PN}/{jmol,examples,doc,contrib} -delete || die

	python_doscript "${FILESDIR}"/{${PN},pdb2pka}

	for lib in apbslib.py{,c,o}; do
		dosym ../../apbs/${lib} $(python_get_sitedir)/${PN}/pdb2pka/${lib}
	done
	dosym ../../_apbslib.so $(python_get_sitedir)/${PN}/pdb2pka/_apbslib.so
	python_optimize

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

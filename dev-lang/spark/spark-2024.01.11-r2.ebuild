# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_14 )
PYTHON_COMPAT=( python3_{10..13} )
inherit ada python-any-r1 multiprocessing

commitId=ce5fad038790d5dc18f9b5345dc604f1ccf45b06
why3Id=fb4ca6cd8c7d888d3e8d281e6de87c66ec20f084

DESCRIPTION="Software development for high-reliability applications"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="https://github.com/AdaCore/spark2014/archive/${commitId}.tar.gz
	-> ${P}.tar.gz
	http://mirror.koddos.net/gcc/releases/gcc-14.2.0/gcc-14.2.0.tar.xz"

S="${WORKDIR}"/spark2014-${commitId}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="doc"

RDEPEND="
	dev-ada/gnatcoll-core[${ADA_USEDEP},shared]
	~dev-ada/gpr-24.2.0[${ADA_USEDEP}]
	sci-mathematics/alt-ergo
	sci-mathematics/why3-for-spark"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"
BDEPEND="doc? (
	$(python_gen_any_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	')
)"

REQUIRED_USE="${ADA_REQUIRED_USE}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

python_check_deps() {
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
	ada_pkg_setup
}

src_prepare() {
	ln -s "${WORKDIR}"/gcc-14.2.0/gcc/ada gnat2why/gnat_src || die
	default
}

src_compile() {
	emake -C gnat2why setup
	gprbuild -j$(makeopts_jobs) -p -XLIBRARY_TYPE=relocatable -v \
		-Pgnat2why/gnat2why.gpr \
		-largs ${LDFLAGS} -cargs ${ADAFLAGS} || die
	gprbuild -j$(makeopts_jobs) -p -XLIBRARY_TYPE=relocatable -v \
		-P gnatprove.gpr \
		-largs ${LDFLAGS} -cargs ${ADAFLAGS} || die
	if use doc; then
		emake -C docs/lrm html
	fi
}

src_install() {

	dodir /usr/bin
	dodir /usr/include/spark
	dodir /usr/lib/spark
	dodir /usr/share/spark/explain_codes
	dodir /usr/share/spark/theories
	dodir /usr/share/spark/runtimes

	gcc -c -gnats spark2014vsn.ads -gnatet="${D}"/usr/bin/target.atp
	insinto /usr/share/spark
	doins share/spark/help.txt
	doins -r share/spark/config
	doins -r share/spark/explain_codes
	insinto /usr/share/spark/theories
	doins share/spark/theories/*why
	doins share/spark/theories/*mlw
	insinto /usr/share/spark/runtimes
	doins share/spark/runtimes/README
	insinto /usr/include/spark
	doins src/spark/*.ad?
	# Create the fake prover scripts to help extract benchmarks.
	insinto /usr/libexec/spark/bin
	doins benchmark_script/fake_*

	dobin install/bin/gnatprove
	exeinto /usr/libexec/spark/bin
	doexe install/bin/gnat2why
	doexe install/bin/spark_memcached_wrapper
	doexe install/bin/spark_report
	doexe install/bin/spark_semaphore_wrapper

	use doc && HTML_DOCS=( docs/lrm/_build/html/* )
	einstalldocs
}

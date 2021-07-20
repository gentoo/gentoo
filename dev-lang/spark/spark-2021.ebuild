# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_2021 )
PYTHON_COMPAT=( python3_{7..9} )

inherit ada python-any-r1 toolchain-funcs multiprocessing

ADA_MIRROR=https://community.download.adacore.com/v1
ID=969ce28e217bd5aa4db549a544d20846408a5229
MYP=${P}-2021-20210519-19A1A-src
GNATID=005d2b2eff627177986d2517eb31e1959bec6f3a
GNATDIR=gnat-${PV}-20210519-19A70-src

DESCRIPTION="Software development for high-reliability applications."
HOMEPAGE="http://libre.adacore.com"
SRC_URI="${ADA_MIRROR}/${ID}?filename=${MYP}.tar.gz -> ${MYP}.tar.gz
	${ADA_MIRROR}/${GNATID}?filename=${GNATDIR}.tar.gz -> ${GNATDIR}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-ada/gnatcoll-core[${ADA_USEDEP},shared]
	sci-mathematics/alt-ergo
	sci-mathematics/why3-for-spark"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-ada/gprbuild[${ADA_USEDEP}]"

REQUIRED_USE="${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

pkg_setup() {
	ada_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	ln -sf "${WORKDIR}"/${GNATDIR}/src/ada gnat2why/gnat_src || die
	default
	sed -i \
		-e "s:gnatls:${GNATLS}:g" \
		src/gnatprove/configuration.adb || die
}

src_compile() {
	emake -C gnat2why GPRARGS="-XLIBRARY_TYPE=relocatable -v"
	gprbuild -p -XLIBRARY_TYPE=relocatable -v -P gnatprove.gpr || die
	emake -C include generate
}

src_install() {
	# Create the fake prover scripts to help extract benchmarks.
	insinto /usr/libexec/spark/bin/
	doins benchmark_script/fake_*

	gprbuild -q -c -u -gnats spark2014vsn.ads \
		-XLIBRARY_TYPE=relocatable -v \
		-gnatet="${D}"/usr/libexec/spark/bin/target.atp || die
	insinto /usr/share/spark
	doins share/spark/help.txt
	doins -r share/spark/config
	insinto /usr/share/spark/theories
	doins share/spark/theories/*why
	doins share/spark/theories/*mlw
	insinto /usr/share/spark/runtimes
	doins share/spark/runtimes/README
	insinto /usr/include/spark
	doins include/*.ad?
	insinto /usr/lib/gnat
	doins include/*.gpr
	doins -r include/proof

	dosym ../../../lib64/why3/why3server /usr/libexec/spark/bin/why3server
	dobin install/bin/gnatprove
	exeinto /usr/libexec/spark/bin
	doexe install/bin/gnat2why
	doexe install/bin/spark_memcached_wrapper
	doexe install/bin/spark_report
	doexe install/bin/spark_codepeer_wrapper
	doexe install/bin/spark_semaphore_wrapper

	einstalldocs
}

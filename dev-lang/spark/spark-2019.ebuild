# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_2019 )
PYTHON_COMPAT=( python2_7 )

inherit ada python-any-r1 toolchain-funcs multiprocessing

DESCRIPTION="Software development for high-reliability applications."
HOMEPAGE="http://libre.adacore.com"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf912431e87a8f1c967d51
	-> ${P}-20190517-19665-src.tar.gz
	http://mirrors.cdn.adacore.com/art/5cdf865331e87aa2cdf16b49
		-> gnat-2019-20190517-18C94-src.tar.gz"

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

S="${WORKDIR}"/${P}-2019-20190517-19665-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

pkg_setup() {
	ada_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	ln -sf "${WORKDIR}"/gnat-2019-20190517-18C94-src/src/ada gnat2why/gnat_src || die
	default
	sed -i \
		-e "s:gnatls:${GNATLS}:g" \
		gnatprove/configuration.adb || die
}

src_compile() {
	emake -C gnat2why GPRARGS="-XLIBRARY_TYPE=relocatable -v"
	emake -C gnatprove PROD="-XLIBRARY_TYPE=relocatable -v"
}

src_install() {
	emake INSTALLDIR="${D}"/usr install
	einstalldocs
	dosym ../../../lib64/why3/why3server /usr/libexec/spark/bin/why3server
	dobin install/bin/gnatprove
	mv install/share/doc/spark/* "${D}"/usr/share/doc/${PF} || die
	exeinto /usr/libexec/spark/bin
	doexe install/bin/gnat2why
	doexe install/bin/spark_memcached_wrapper
	doexe install/bin/spark_report
	doexe install/bin/spark_codepeer_wrapper
	mv "${D}"/usr/bin/target.atp "${D}"/usr/libexec/spark/bin || die
}

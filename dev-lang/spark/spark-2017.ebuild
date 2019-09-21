# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="Software development for high-reliability applications."
HOMEPAGE="http://libre.adacore.com"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c4777c7a447af2deed05e
	-> ${MYP}-src.tar.gz
	http://mirrors.cdn.adacore.com/art/591adbb4c7a4473fcc4532a3
		-> gnat-gpl-2017-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="dev-lang/gnat-gpl:6.3.0
	>=dev-ada/gnatcoll-2017[gnat_2017,projects,shared]
	sci-mathematics/alt-ergo
	sci-mathematics/why3-for-spark"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2017]"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	ln -sf "${WORKDIR}"/gnat-gpl-2017-src/src/ada gnat2why/gnat_src || die
	GCC_PV=6.3.0
	sed -i \
		-e "s:gnatmake:gnatmake-${GCC_PV}:g" \
		-e "s:gnatls:gnatls-${GCC_PV}:g" \
		Makefile \
		gnat2why/Makefile || die
	default
}

src_compile() {
	emake GPRARGS="-XLIBRARY_TYPE=relocatable" gnat2why
	emake PROD="-XLIBRARY_TYPE=relocatable" gnatprove
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

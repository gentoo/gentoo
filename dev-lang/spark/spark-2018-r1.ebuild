# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_2018 )
inherit ada toolchain-funcs multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="Software development for high-reliability applications."
HOMEPAGE="http://libre.adacore.com"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0819dec7a447df26c27a47
	-> ${MYP}-src.tar.gz
	http://mirrors.cdn.adacore.com/art/5b0819dfc7a447df26c27aa5
		-> gnat-gpl-2018-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-ada/gnatcoll-core[${ADA_USEDEP},shared]
	sci-mathematics/alt-ergo
	sci-mathematics/why3-for-spark"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

REQUIRED_USE="${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${PN}-2017-gentoo.patch )

src_prepare() {
	ln -sf "${WORKDIR}"/gnat-gpl-2018-src/src/ada gnat2why/gnat_src || die
	sed -i \
		-e "s:gnatls:${GNATLS}:g" \
		gnatprove/configuration.adb || die
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

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multiprocessing

MYP=gprbuild-${PV}-20190517-194D8

DESCRIPTION="Ada library to handle GPRbuild project files"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf8e8031e87a8f1d425093
		-> ${MYP}-src.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2016 gnat_2017 gnat_2018 +gnat_2019 +shared static-libs static-pic"

RDEPEND="dev-ada/xmlada[shared?,static-libs?,static-pic?]
	dev-ada/xmlada[gnat_2016(-)?,gnat_2017(-)?,gnat_2018(-)?,gnat_2019(-)?]
	!net-libs/grpc"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2016(-)?,gnat_2017(-)?,gnat_2018(-)?,gnat_2019(-)?]"

S="${WORKDIR}"/${MYP}-src

src_configure() {
	emake prefix="${D}"/usr setup
}

src_compile() {
	build () {
		gprbuild -p -m -j$(makeopts_jobs) -XBUILD=production -v \
			-XLIBRARY_TYPE=$1 -XXMLADA_BUILD=$1 \
			gpr/gpr.gpr -cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} || die
	}
	if use shared; then
		build relocatable
	fi
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi
}

src_install() {
	if use static-libs; then
		emake DESTDIR="${D}" libgpr.install.static
	fi
	for kind in shared static-pic; do
		if use ${kind}; then
			emake DESTDIR="${D}" libgpr.install.${kind}
		fi
	done
	rm -r "${D}"/usr/share/gpr/manifests || die
	einstalldocs
}

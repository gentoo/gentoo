# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs multiprocessing

MYP=gprbuild-gpl-${PV}

DESCRIPTION="Ada library to handle GPRbuild project files"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deecff7
		-> ${MYP}-src.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2016 +gnat_2017 +shared static-libs static-pic"

RDEPEND="dev-ada/xmlada[static-libs,gnat_2016=,gnat_2017=]"
DEPEND="${RDEPEND}
	dev-ada/gprbuild"

S="${WORKDIR}"/${MYP}-src

REQUIRED_USE="|| ( shared static-libs static-pic )"
PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure() {
	emake prefix="${D}"usr setup
}

src_compile() {
	build () {
		gprbuild -p -m -j$(makeopts_jobs) -XBUILD=production -v \
			-XLIBRARY_TYPE=$1 -XXMLADA_BUILD=$1 \
			gpr/gpr.gpr -cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} || die
	}
	if use gnat_2016; then
		GCC_PV=4.9.4
	else
		GCC_PV=6.3.0
	fi
	GCC=${CHOST}-gcc-${GCC_PV}
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
}

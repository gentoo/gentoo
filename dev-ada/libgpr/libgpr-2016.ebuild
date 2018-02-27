# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs multiprocessing

MYP=gprbuild-gpl-${PV}

DESCRIPTION="Ada library to handle GPRbuild project files"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/57399662c7a447658e0affa8
		-> ${MYP}-src.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gnat_2016 gnat_2017 +shared static-libs static-pic"

RDEPEND="dev-ada/xmlada[gnat_2016=,gnat_2017=]"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2016=,gnat_2017=]"

S="${WORKDIR}"/${MYP}-src

REQUIRED_USE="|| ( shared static-libs static-pic )"
PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_compile() {
	if use gnat_2016; then
		GCC_PV=4.9.4
	else
		GCC_PV=6.3.0
	fi
	GCC=${CHOST}-gcc-${GCC_PV}
	if use static-libs; then
		emake PROCESSORS=$(makeopts_jobs) libgpr.build.static
	fi
	for kind in shared static-pic; do
		if use ${kind}; then
			emake PROCESSORS=$(makeopts_jobs) libgpr.build.${kind}
		fi
	done
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

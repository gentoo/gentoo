# Copyright 1999-2017 Gentoo Foundation
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
KEYWORDS="~amd64"
IUSE="+gnat_2016 gnat_2017 +shared static static-pic"

RDEPEND="dev-ada/xmlada[gnat_2016=,gnat_2017=]
	gnat_2016? ( dev-lang/gnat-gpl:4.9.4 )
	gnat_2017? ( dev-lang/gnat-gpl:6.3.0 )"
DEPEND="${RDEPEND}
	dev-ada/gprbuild"

S="${WORKDIR}"/${MYP}-src

REQUIRED_USE="|| ( shared static static-pic )
	^^ ( gnat_2016 gnat_2017 )"
PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_compile() {
	if use gnat_2016; then
		GCC_PV=4.9.4
	else
		GCC_PV=6.3.0
	fi
	GCC=${CHOST}-gcc-${GCC_PV}
	for kind in shared static static-pic; do
		if use ${kind}; then
			emake PROCESSORS=$(makeopts_jobs) libgpr.build.${kind}
		fi
	done
}

src_install() {
	for kind in shared static static-pic; do
		if use ${kind}; then
			emake DESTDIR="${D}" libgpr.install.${kind}
		fi
	done
}

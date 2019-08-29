# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="Provides access to GNAT compiler internals for AdaCore utilities"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deed037
	-> ${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnat_2016 +gnat_2017 +shared static-libs static-pic"

RDEPEND="gnat_2016? ( dev-lang/gnat-gpl:4.9.4 )
	gnat_2017? ( dev-lang/gnat-gpl:6.3.0 )"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2016(-)?,gnat_2017(-)?]"
REQUIRED_USE="^^ ( gnat_2016 gnat_2017 )"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_compile() {
	if use gnat_2016; then
		GCC_PV=4.9.4
	else
		GCC_PV=6.3.0
	fi
	GNATMAKE=${CHOST}-gnatmake-${GCC_PV}
	emake GNATMAKE="${GNATMAKE} ${ADAFLAGS}" \
		BUILDER="gprbuild -j$(makeopts_jobs)" generate_sources
	if use static-libs; then
		emake BUILDER="gprbuild -v -j$(makeopts_jobs)" build-static
	fi
	for kind in shared static-pic; do
		if use ${kind}; then
			emake BUILDER="gprbuild -v -j$(makeopts_jobs)" \
				build-${kind}
		fi
	done
}

src_install() {
	if use static-libs; then
		emake prefix="${D}"/usr install-static
	fi
	for kind in shared static-pic; do
		if use ${kind}; then
			emake prefix="${D}"/usr install-${kind}
		fi
	done
	einstalldocs
}

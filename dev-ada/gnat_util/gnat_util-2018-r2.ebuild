# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_201{8,9} )
inherit ada toolchain-funcs multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="Provides access to GNAT compiler internals for AdaCore utilities"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0819dfc7a447df26c27a6b
	-> ${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+shared static-libs static-pic"

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"
REQUIRED_USE="${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${PN}-2017-gentoo.patch )

src_compile() {
	emake GNATMAKE="gnatmake ${ADAFLAGS}" \
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

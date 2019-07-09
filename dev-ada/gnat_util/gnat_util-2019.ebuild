# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multiprocessing

MYP=${P}-20190517

DESCRIPTION="Provides access to GNAT compiler internals for AdaCore utilities"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf8e5031e87a8f1d425090
	-> ${MYP}-18c94-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gnat_2019 +shared static-libs static-pic"

RDEPEND="dev-lang/gnat-gpl:8.3.1"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2019]"
REQUIRED_USE="gnat_2019"

S="${WORKDIR}"/${MYP}-194CA-src

PATCHES=( "${FILESDIR}"/${PN}-2017-gentoo.patch )

src_compile() {
	GCC_PV=8.3.1
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

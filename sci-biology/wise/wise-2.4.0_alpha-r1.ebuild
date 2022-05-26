# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PV="${PV/_}"
MY_P="${PN}${MY_PV}"
DESCRIPTION="Intelligent algorithms for DNA searches"
HOMEPAGE="http://www.ebi.ac.uk/Wise2/"
SRC_URI="
	ftp://ftp.ebi.ac.uk/pub/software/${PN}2/${MY_P}.tar.gz
	https://dev.gentoo.org/~mgorny/dist/${P}-patchset.tar.bz2
"
S="${WORKDIR}"/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="~sci-biology/hmmer-2.3.2"
DEPEND="${RDEPEND}"
BDEPEND="
	app-shells/tcsh
	dev-lang/perl
	virtual/latex-base
"

PATCHES=(
	"${WORKDIR}"/${P}-patchset/${P}-glibc-2.10.patch
	"${WORKDIR}"/${P}-patchset/${P}-cflags.patch
)

src_prepare() {
	default
	cd docs || die
	cat ../src/models/*.tex ../src/dynlibsrc/*.tex | perl gettex.pl > temp.tex || die
	cat wise2api.tex temp.tex apiend.tex > api.tex || die
	eapply "${FILESDIR}"/${PN}-api.tex.patch
}

src_compile() {
	tc-export CC
	emake -C src all

	if use doc; then
		cd docs || die
		for i in api appendix dynamite wise2 wise3arch; do
			latex ${i} || die
			latex ${i} || die
			dvips ${i}.dvi -o || die
		done
	fi
}

src_test() {
	cd src || die
	WISECONFIGDIR="${S}/wisecfg" emake test
}

src_install() {
	dobin src/bin/* src/dynlibsrc/testgendb

	insinto /usr/share/${PN}
	doins -r wisecfg

	use doc && dodoc docs/*.ps
	newenvd "${WORKDIR}"/${P}-patchset/${PN}-env 24wise
}

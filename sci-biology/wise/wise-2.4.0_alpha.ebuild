# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/wise/wise-2.4.0_alpha.ebuild,v 1.6 2015/04/19 10:02:55 ago Exp $

EAPI=5

inherit eutils toolchain-funcs versionator

DESCRIPTION="Intelligent algorithms for DNA searches"
HOMEPAGE="http://www.ebi.ac.uk/Wise2/"
SRC_URI="ftp://ftp.ebi.ac.uk/pub/software/${PN}2/${PN}$(delete_version_separator 3).tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ia64 ~sparc x86"
IUSE="doc static-libs"

RDEPEND="~sci-biology/hmmer-2.3.2"
DEPEND="
	${RDEPEND}
	app-shells/tcsh
	dev-lang/perl
	virtual/latex-base"

S="${WORKDIR}"/${PN}$(delete_version_separator 3)

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-glibc-2.10.patch \
		"${FILESDIR}"/${P}-cflags.patch
	cd "${S}"/docs || die
	cat "${S}"/src/models/*.tex "${S}"/src/dynlibsrc/*.tex | perl gettex.pl > temp.tex || die
	cat wise2api.tex temp.tex apiend.tex > api.tex || die
	epatch "${FILESDIR}"/${PN}-api.tex.patch
}

src_compile() {
	emake \
		-C src \
		CC="$(tc-getCC)" \
		all
	if use doc; then
		cd "${S}"/docs || die
		for i in api appendix dynamite wise2 wise3arch; do
			latex ${i} || die
			latex ${i} || die
			dvips ${i}.dvi -o || die
		done
	fi
}

src_test() {
	cd "${S}"/src || die
	WISECONFIGDIR="${S}/wisecfg" emake test
}

src_install() {
	dobin "${S}"/src/bin/* "${S}"/src/dynlibsrc/testgendb
	use static-libs && \
		dolib.a \
			"${S}"/src/base/libwisebase.a \
			"${S}"/src/dynlibsrc/libdyna.a \
			"${S}"/src/models/libmodel.a

	insinto /usr/share/${PN}
	doins -r "${S}"/wisecfg

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${S}"/docs/*.ps
	fi
	newenvd "${FILESDIR}"/${PN}-env 24wise || die "Failed to install env file"
}

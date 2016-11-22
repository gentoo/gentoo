# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

MY_P="${PN}${PV}_lite"

DESCRIPTION="lite version of pNMRsim"
HOMEPAGE="http://www.dur.ac.uk/paul.hodgkinson/pNMRsim/"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_sse threads"

RDEPEND="sci-libs/minuit"
DEPEND="${RDEPEND}"

RESTRICT=mirror

S="${WORKDIR}/${PN}R3"

DOCS=( CHANGES docs/cmatrix.pdf )
PATCHES=(
	"${FILESDIR}/${PN}-3.11.0-shared.patch"
	"${FILESDIR}/${PN}-3.2.1-minuit2.patch"
	"${FILESDIR}/${PN}-3.2.1-gcc4.4.patch"
	"${FILESDIR}/${PN}-3.2.1-gcc4.6.patch"
	"${FILESDIR}/${PN}-3.2.1-gcc4.7.patch"
	"${FILESDIR}/${PN}-3.9.0-atlas.patch"
	"${FILESDIR}/${PN}-3.11.0-gcc5.2.patch"
	"${FILESDIR}/${PN}-3.11.0-fix-c++14.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-minuit \
		--without-atlas \
		--with-sysroot="${EROOT}" \
		$(use_with cpu_flags_x86_sse sse) \
		$(use_with threads)
}

src_install() {
	dolib.so lib/*.so*

	insinto /usr/include/${PN}R3
	doins -r include/.

	einstalldocs
}

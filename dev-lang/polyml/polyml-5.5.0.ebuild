# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/polyml/polyml-5.5.0.ebuild,v 1.4 2015/07/09 09:46:32 gienah Exp $

EAPI="5"

inherit base autotools versionator

# Although the download is called 5.5, after building it poly -v says
# it is 5.5.0.
MY_PV=$(get_version_component_range "1-2" "${PV}")
MY_P="${PN}.${MY_PV}"

DESCRIPTION="Poly/ML is a full implementation of Standard ML"
HOMEPAGE="http://www.polyml.org"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="X elibc_glibc +gmp portable test +threads"

RDEPEND="X? ( x11-libs/motif:0 )
		gmp? ( >=dev-libs/gmp-5 )
		elibc_glibc? ( threads? ( >=sys-libs/glibc-2.13 ) )
		virtual/libffi"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=("${FILESDIR}/${PN}-5.5.0-configure.patch"
	"${FILESDIR}/${PN}-5.5.0-x-it-basis.patch"
	"${FILESDIR}/${PN}-5.5.0-asm.patch")

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		--with-system-libffi \
		$(use_with X x) \
		$(use_with gmp) \
		$(use_with portable) \
		$(use_with threads)
}

src_test() {
	emake tests || die "tests failed"
}

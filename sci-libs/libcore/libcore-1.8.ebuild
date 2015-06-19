# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libcore/libcore-1.8.ebuild,v 1.1 2009/02/02 23:01:37 bicatali Exp $

EAPI=2
inherit eutils toolchain-funcs

MYP="${PN/lib}_v${PV}"

DESCRIPTION="Robust numerical and geometric computation library"
HOMEPAGE="http://www.cs.nyu.edu/exact/core_pages/"
SRC_URI="http://cs.nyu.edu/exact/core/download/${MYP}/${MYP}.tgz
	doc? ( http://cs.nyu.edu/exact/core/download/${MYP}/${MYP}_doc.tgz )"

LICENSE="QPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-libs/gmp"
RDEPEND=""

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.7.patch
	sed -i \
		-e "s/-O2/${CXXFLAGS}/g" \
		-e "s/-shared/-shared ${LDFLAGS}/g" \
		Make.config || die
}

src_compile(){
	emake LINKAGE=shared corelib corex || die "emake shared failed"
	emake -C src clean && emake -C ext clean
	emake corelib corex || die "emake static failed"
	if use doc; then
		cd "${S}/doc"
		emake -j1 all || die "doc creation failed"
		emake -j1 -C doxy/latex pdf || die "pdf doc creation failed"
	fi
}

src_install(){
	dolib lib/*.a lib/*.so || die "Unable to find libraries"
	for i in $(find "${D}/usr/$(get_libdir)" -name "*so" | sed "s:${D}::g"); do
		dosym $i $i.1 && dosym $i $i.1.0.0 || die "Unable to sym $i"
	done

	dodir /usr/include || die "Unable to create include dir"
	cp -r ./inc/* "${D}/usr/include/" || die "Unable to copy headers"

	dodoc FAQs README || die "Unable to install default doc"
	if use doc; then
		dodoc doc/*.txt
		insinto /usr/share/doc/${PF}
		doins doc/papers/* doc/tutorial/tutorial.pdf || die
		doins -r doc/doxy/html doc/doxy/latex/*pdf || die
	fi
}

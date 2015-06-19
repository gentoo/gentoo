# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/minuit/minuit-5.28.00.ebuild,v 1.1 2011/03/07 05:28:28 bicatali Exp $

EAPI=4
inherit autotools eutils toolchain-funcs

MY_PN=Minuit2

DESCRIPTION="A C++ physics analysis tool for function minimization"
HOMEPAGE="http://seal.web.cern.ch/seal/MathLibs/Minuit2/html/index.html"

SRC_URI="http://seal.web.cern.ch/seal/MathLibs/${MY_PN}/${MY_PN}-${PV}.tar.gz
	doc? ( http://seal.cern.ch/documents/minuit/mnusersguide.pdf
		   http://seal.cern.ch/documents/minuit/mntutorial.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc openmp static-libs"
DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.27.02-asneeded.patch
	rm config/m4/ac_openmp.m4
	AT_M4DIR="config/m4" eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable openmp)
}

src_compile() {
	emake
	use doc && emake docs
}

src_test() {
	emake check
	cd test/MnTutorial
	local t
	for t in test_*; do
			./${t} || die "${t} failed"
	done
}

src_install() {
	emake DESTDIR="${D}" install
	insinto /usr/share/doc/${PF}/MnTutorial
	doins test/MnTutorial/*.{h,cxx}
	if use doc; then
		dodoc "${DISTDIR}"/mn*.pdf
		dohtml -r doc/html/*
	fi
}

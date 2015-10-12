# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils flag-o-matic fortran-2 multilib toolchain-funcs

DESCRIPTION="molecular replacement program"
HOMEPAGE="http://www.ysbl.york.ac.uk/~alexei/molrep.html"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=sci-libs/ccp4-libs-6.1.3
	sci-libs/mmdb
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch \
		"${FILESDIR}"/11.0.00-respect-FLAGS.patch \
		"${FILESDIR}"/11.0.00-test.patch \
		"${FILESDIR}"/${PV}-EOR.patch
	[[ $(tc-getFC) =~ gfortran ]] && append-fflags -fno-second-underscore
}

src_compile() {
	cd "${S}"/src
	emake clean
	emake \
		MR_FORT="$(tc-getFC) ${FFLAGS}" \
		FFLAGS="${FFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		MR_LIBRARY="-L${EPREFIX}/usr/$(get_libdir) -lccp4f -lccp4c $($(tc-getPKG_CONFIG) --libs mmdb lapack) -lccif -lstdc++ -lm"
}

src_test() {
	export MR_TEST="${S}/bin/"
	cd "${S}"/molrep_check/work
	mkdir out scr
	cp ../*.bat .
	bash em.bat || die
	bash mr.bat || die
}

src_install() {
	exeinto /usr/libexec/ccp4/bin/
	doexe bin/${PN}
	dosym ../libexec/ccp4/bin/${PN} /usr/bin/${PN}
	dodoc readme doc/${PN}.rtf
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils fortran-2 flag-o-matic toolchain-funcs versionator

DESCRIPTION="Macromolecular crystallographic refinement program"
HOMEPAGE="http://www.ysbl.york.ac.uk/~garib/refmac"
SRC_URI="
	${HOMEPAGE}/data/refmac_stable/refmac_${PV}.tar.gz
	test? ( http://dev.gentooexperimental.org/~jlec/distfiles/test-framework.tar.gz )"

SLOT="0"
LICENSE="ccp4"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	sci-chemistry/makecif
	>=sci-libs/ccp4-libs-6.1.3-r7
	sci-libs/mmdb
	<sci-libs/monomer-db-1
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

FORTRAN_STANDARD="77 90"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${PV}-allow-dynamic-linking.patch
	"${FILESDIR}"/${PV}-gcc4.6.patch
	)

src_prepare() {
	epatch ${PATCHES[@]}

	use test && epatch "${FILESDIR}"/$(get_version_component_range 1-2 ${PV})-test.log.patch
	[[ ${FC} == *gfortran* ]] && \
		append-fflags -fno-second-underscore && \
		append-cflags -DGFORTRAN -DPROTOTYPE && \
		append-libs -lgfortran -lgfortranbegin -lstdc++
	[[ ${FC} == *ifort* ]] && \
		append-libs -lstdc++
}

src_compile() {
	emake \
		FC=$(tc-getFC) \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		COPTIM="${CFLAGS}" \
		FOPTIM="${FFLAGS:- -O2}" \
		VERSION="" \
		XFFLAGS="" \
		XCFLAGS="" \
		LLIBCCP="-lccp4f -lccp4c -lccif $($(tc-getPKG_CONFIG) --libs mmdb)" \
		LLIBLAPACK="$($(tc-getPKG_CONFIG) --libs lapack blas)" \
		LLIBOTHERS="${LIBS}" \
		${PN} libcheck
}

src_test() {
	einfo "Starting tests ..."
	source "${EPREFIX}/etc/profile.d/40ccp4.setup.sh"
	export PATH="${WORKDIR}/test-framework/scripts:${S}:${PATH}"
	export CCP4_TEST="${WORKDIR}"/test-framework
	export CCP4_SCR="${T}"
	ln -sf refmac "${S}"/refmac5
	sed '/^ANISOU/d' -i ${CCP4_TEST}/data/pdb/1vr7.pdb
	ccp4-run-thorough-tests -v test_refmac5 || die
}

src_install() {
	exeinto /usr/libexec/ccp4/bin/
	doexe ${PN}
	dosym refmac /usr/libexec/ccp4/bin/refmac5
	dosym ../libexec/ccp4/bin/${PN} /usr/bin/${PN}
	dosym refmac /usr/bin/refmac5
	dodoc refmac_keywords.pdf bugs_and_features.pdf
}

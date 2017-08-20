# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils elisp-common flag-o-matic multilib prefix python-single-r1 versionator

MY_PN=Singular
MY_PV=$(replace_all_version_separators -)
MY_DIR=$(get_version_component_range 1-3 ${MY_PV})
# Note: Upstream's share tarball may not get updated on every release
MY_SHARE_DIR="3-1-6"
MY_PV_SHARE="${MY_PV}"

DESCRIPTION="Computer algebra system for polynomial computations"
HOMEPAGE="http://www.singular.uni-kl.de/"

SRC_COM="http://www.mathematik.uni-kl.de/ftp/pub/Math/${MY_PN}/SOURCES/"
SRC_URI="${SRC_COM}${MY_DIR}/${MY_PN}-${MY_PV}.tar.gz
		 ${SRC_COM}${MY_SHARE_DIR}/${MY_PN}-${MY_PV_SHARE}-share.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="boost doc emacs examples python readline test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/ntl:0=
	emacs? ( >=virtual/emacs-22 )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )"
DEPEND="${RDEPEND}
	dev-lang/perl
	boost? ( dev-libs/boost:0= )"

# Upstream does not care about tests
RESTRICT="test"

S="${WORKDIR}/${MY_PN}-${MY_DIR}"

pkg_setup() {
	append-flags -fPIC
	append-ldflags -fPIC
	tc-export CC CPP CXX
	use emacs && elisp-need-emacs 22
	use python && python-single-r1_pkg_setup
}

src_prepare () {
	epatch \
		"${FILESDIR}"/${PN}-3.1.0-gentoo.patch \
		"${FILESDIR}"/${PN}-3.1.0-emacs-22.patch \
		"${FILESDIR}"/${PN}-3.0.4.4-nostrip.patch \
		"${FILESDIR}"/${PN}-3.1.3.3-Minor.h.patch \
		"${FILESDIR}"/${PN}-3.1.6-ntl6compat.patch \
		"${FILESDIR}"/${PN}-3.1.6-factory_template_instantiation.patch
	use python && epatch "${FILESDIR}"/${PN}-3.1.3.2-python.patch

	if  [[ ${CHOST} == *-darwin* ]] ; then
		epatch "${FILESDIR}"/${PN}-3.1.3.3-install_name.patch
		eprefixify kernel/Makefile.in
		eprefixify Singular/Makefile.in
	fi

	eprefixify kernel/feResource.cc

	# The SLDFLAGS mangling prevents passing raw LDLAGS to gcc (see e.g. bug 414709)
	sed -i \
		-e "/CXXFLAGS/ s/--no-exceptions//g" \
		-e "s/SLDFLAGS=-shared/SLDFLAGS=\"$(raw-ldflags) -shared\"\n\t  \tSLDFLAGS2=\"${LDFLAGS} -shared\"/" \
		-e "s/  SLDFLAGS=/  SLDFLAGS=\n  SLDFLAGS2=/" \
		-e "s/AC_SUBST(SLDFLAGS)/AC_SUBST(SLDFLAGS)\nAC_SUBST(SLDFLAGS2)/" \
		"${S}"/Singular/configure.in || die

	sed -i \
		-e "s/@SLDFLAGS@/@SLDFLAGS@\nSLDFLAGS2\t= @SLDFLAGS2@/" \
		-e "/\$(CXX).*SLDFLAGS/s/SLDFLAGS/SLDFLAGS2/" \
		"${S}"/Singular/Makefile.in || die

	# remove ntl sources for safety.
	rm -r ntl || die

	cd "${S}"/Singular || die "failed to cd into Singular/"

	eautoconf
}

src_configure() {
	econf \
		--prefix="${S}"/build \
		--exec-prefix="${S}"/build \
		--bindir="${S}"/build/bin \
		--libdir="${S}"/build/lib \
		--libexecdir="${S}"/build/lib \
		--includedir="${S}"/build/include \
		--with-apint=gmp \
		--with-NTL \
		--disable-doc \
		--without-MP \
		--without-flint \
		--enable-factory \
		--enable-libfac \
		--enable-IntegerProgramming \
		--enable-Singular \
		--with-malloc=system \
		$(use_with python python embed) \
		$(use_with boost Boost) \
		$(use_enable emacs) \
		$(use_with readline)
}

src_compile() {
	emake
	if use emacs; then
		cd "${WORKDIR}"/${MY_PN}/${MY_SHARE_DIR}/emacs/
		elisp-compile *.el
	fi
}

src_test() {
	# Tests fail to link -lsingular, upstream ticket #243
	emake test
}

src_install () {
	dodoc README
	# execs and libraries
	cd "${S}"/build/bin
	dobin ${MY_PN}* gen_test change_cost solve_IP toric_ideal LLL
	insinto /usr/$(get_libdir)/${PN}
	doins *.so

	dosym ${MY_PN}-${MY_DIR} /usr/bin/${MY_PN}
	dosym ${MY_PN}-${MY_DIR} /usr/bin/${PN}

	# stuff from the share tar ball
	cd "${WORKDIR}"/${MY_PN}/${MY_SHARE_DIR}
	insinto /usr/share/${PN}
	doins -r LIB
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
	if use doc; then
		dohtml -r html/*
		insinto /usr/share/${PN}
		doins doc/singular.idx
		cp info/${PN}.hlp info/${PN}.info &&
		doinfo info/${PN}.info
	fi
	if use emacs; then
		elisp-install ${PN} emacs/*.el emacs/*.elc emacs/.emacs*
		elisp-site-file-install "${FILESDIR}"/60${PN}-gentoo.el
	fi
}

pkg_postinst() {
	einfo "The authors ask you to register as a SINGULAR user."
	einfo "Please check the license file for details."
	if use emacs; then
		echo
		ewarn "Please note that the ESingular emacs wrapper has been"
		ewarn "removed in favor of full fledged singular support within"
		ewarn "Gentoo's emacs infrastructure; i.e. just fire up emacs"
		ewarn "and you should be good to go! See bug #193411 for more info."
		echo
	fi
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

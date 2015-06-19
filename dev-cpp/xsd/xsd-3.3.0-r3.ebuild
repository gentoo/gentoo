# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/xsd/xsd-3.3.0-r3.ebuild,v 1.3 2014/08/10 19:56:05 slyfox Exp $

EAPI=5

inherit toolchain-funcs eutils versionator

DESCRIPTION="An open-source, cross-platform W3C XML Schema to C++ data binding compiler"
HOMEPAGE="http://www.codesynthesis.com/products/xsd/"
SRC_URI="http://www.codesynthesis.com/download/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="ace doc examples test zlib"

RDEPEND=">=dev-libs/xerces-c-3
	>=dev-libs/boost-1.52.0-r1:=[threads]
	>=dev-cpp/libcult-1.4.6-r1
	>=dev-cpp/libxsd-frontend-1.18.0-r1
	>=dev-cpp/libbackend-elements-1.7.2
	ace? ( dev-libs/ace )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	dev-util/build
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch \
		"${FILESDIR}/${PV}-disable_examples_and_tests.patch" \
		"${FILESDIR}/${PV}-xsdcxx-rename.patch" \
		"${FILESDIR}/${PV}-fix_include.patch" \
		"${FILESDIR}/${PV}-fix_tests.patch" \
		"${FILESDIR}/${PV}-boost-filesystem-v2-deprecation.patch"
}

src_configure() {
	# Maintainer notes:
	# * xqilla is not required, this is only whether or not to include the xpath
	#   examples which require xqilla
	mkdir -p \
		build/cxx/gnu \
		build/import/lib{ace,boost,cult,backend-elements,xerces-c,xqilla,xsd-frontend,z}

	cat >> build/configuration-dynamic.make <<- EOF
xsd_with_zlib := $(usex zlib y n)
xsd_with_ace := $(usex ace y n)
xsd_with_xdr := y
xsd_with_dbxml := n
xsd_with_xqilla := y
xsd_with_boost_date_time := y
xsd_with_boost_serialization := y
	EOF

	cat >> build/cxx/configuration-dynamic.make <<- EOF
cxx_id       := gnu
cxx_optimize := n
cxx_debug    := n
cxx_rpath    := n
cxx_pp_extra_options :=
cxx_extra_options    := ${CXXFLAGS}
cxx_ld_extra_options := ${LDFLAGS}
cxx_extra_libs       :=
cxx_extra_lib_paths  :=
	EOF

	cat >> build/cxx/gnu/configuration-dynamic.make <<- EOF
cxx_gnu := $(tc-getCXX)
cxx_gnu_libraries :=
cxx_gnu_optimization_options :=
	EOF

	cat >> build/import/libace/configuration-dynamic.make <<- EOF
libace_installed := y
	EOF

	cat >> build/import/libbackend-elements/configuration-dynamic.make <<- EOF
libbackend_elements_installed := y
	EOF

	cat >> build/import/libboost/configuration-dynamic.make <<- EOF
libboost_installed := y
libboost_system := y
	EOF

	cat >> build/import/libcult/configuration-dynamic.make <<- EOF
libcult_installed := y
	EOF

	cat >> build/import/libxerces-c/configuration-dynamic.make <<- EOF
libxerces_c_installed := y
	EOF

	cat >> build/import/libxqilla/configuration-dynamic.make <<- EOF
libxqilla_installed := y
	EOF

	cat >> build/import/libxsd-frontend/configuration-dynamic.make <<- EOF
libxsd_frontend_installed := y
	EOF

	cat >> build/import/libz/configuration-dynamic.make <<- EOF
libz_installed := y
	EOF

	MAKEOPTS+=" verbose=1"
}

src_compile() {
	default
	if use doc ; then
		emake -C "${S}/documentation/cxx/tree/reference" || die "generating reference docs failed"
	fi
	if use test ; then
		XERCESC_NLS_HOME="${ROOT}usr/share/xerces-c/msg" emake -C "${S}/tests" || die "building tests failed"
	fi
}

src_install() {
	emake install_prefix="${D}/usr" install || die "emake install failed"

	# Renaming binary/manpage to avoid collision with mono-2.0's xsd/xsd2
	mv "${D}"/usr/bin/xsd{,cxx}
	mv "${D}"/usr/share/man/man1/xsd{,cxx}.1

	rm -rf "${D}/usr/share/doc"

	dohtml -r -A xhtml -A pdf documentation/*

	dodoc NEWS README FLOSSE documentation/custom-literals.xsd
	newdoc libxsd/README README.libxsd
	newdoc libxsd/FLOSSE FLOSSE.libxsd

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

src_test() {
	XERCESC_NLS_HOME="${ROOT}usr/share/xerces-c/msg" emake -C "${S}/tests" test || die "tests failed"
}

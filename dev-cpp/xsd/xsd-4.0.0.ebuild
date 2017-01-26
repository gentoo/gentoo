# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs versionator

DESCRIPTION="An open-source, cross-platform W3C XML Schema to C++ data binding compiler"
HOMEPAGE="http://www.codesynthesis.com/products/xsd/"
SRC_URI="http://www.codesynthesis.com/download/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="ace doc examples test zlib"

RDEPEND="
	>=dev-libs/xerces-c-3.0.0
	dev-libs/boost:=[threads]
	dev-cpp/libcutl
	>=dev-cpp/libxsd-frontend-2.0.0
	ace? ( dev-libs/ace )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	dev-util/build
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.0-disable_examples_and_tests.patch"
	"${FILESDIR}/${PN}-4.0.0-xsdcxx-rename.patch"
	"${FILESDIR}/${PN}-4.0.0-fix-expat-support.patch"
	"${FILESDIR}/${PN}-4.0.0-fix-include.patch"
)

src_configure() {
	# Maintainer notes:
	# * xqilla is not required, this is only whether or not to include the xpath
	#   examples which require xqilla
	mkdir -p \
		build/cxx/gnu \
		build/import/lib{ace,boost,cult,backend-elements,xerces-c,xqilla,xsd-frontend,z} || die

	cat >> build/configuration-dynamic.make <<- EOF || die
		xsd_with_zlib := $(usex zlib y n)
		xsd_with_ace := $(usex ace y n)
		xsd_with_xdr := y
		xsd_with_xqilla := y
		xsd_with_boost_date_time := y
		xsd_with_boost_serialization := y
	EOF

	cat >> build/cxx/configuration-dynamic.make <<- EOF || die
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

	cat >> build/cxx/gnu/configuration-dynamic.make <<- EOF || die
		cxx_gnu := $(tc-getCXX)
		cxx_gnu_libraries :=
		cxx_gnu_optimization_options :=
	EOF

	# cli
	cat >> build/import/cli/configuration-dynamic.make <<- EOF || die
		cli_installed := y
	EOF

	# ace
	cat >> build/import/libace/configuration-dynamic.make <<- EOF || die
		libace_installed := y
	EOF

	# boost
	cat >> build/import/libboost/configuration-dynamic.make <<- EOF || die
		libboost_installed := y
		libboost_system := y
	EOF

	# libcutl
	cat >> build/import/libcutl/configuration-dynamic.make <<- EOF || die
		libcutl_installed := y
	EOF

	# xerces-c
	cat >> build/import/libxerces-c/configuration-dynamic.make <<- EOF || die
		libxerces_c_installed := y
	EOF

	# xqilla
	cat >> build/import/libxqilla/configuration-dynamic.make <<- EOF || die
		libxqilla_installed := y
	EOF

	# libxsd-frontend
	cat >> build/import/libxsd-frontend/configuration-dynamic.make <<- EOF || die
		libxsd_frontend_installed := y
	EOF

	# zlib
	cat >> build/import/libz/configuration-dynamic.make <<- EOF || die
		libz_installed := y
	EOF
}

src_compile() {
	emake verbose=1

	if use doc; then
		emake -C "${S}/doc/cxx/tree/reference" verbose=1
	fi
	if use test; then
		XERCESC_NLS_HOME="${EPREFIX}/usr/share/xerces-c/msg" emake -C tests verbose=1
	fi
}

src_test() {
	XERCESC_NLS_HOME="${EPREFIX}/usr/share/xerces-c/msg" emake -C tests test
}

src_install() {
	emake install_prefix="${ED%/}/usr" install

	# Renaming binary/manpage to avoid collision with mono-2.0's xsd/xsd2
	mv "${ED%/}"/usr/bin/xsd{,cxx} || die
	mv "${ED%/}"/usr/share/man/man1/xsd{,cxx}.1 || die

	# remove incorrectly installed documentation
	rm -rf "${ED%/}/usr/share/doc" || die
	# clean out all non-html related files
	find doc/ \( -iname '*.1' -o -iname 'makefile*' -o -iname '*doxygen' \
		-o -iname '*doxytag' -o -iname '*html2ps' \) -delete || die

	DOCS=( NEWS README FLOSSE )
	HTML_DOCS=( doc/. )
	einstalldocs

	newdoc libxsd/README README.libxsd
	newdoc libxsd/FLOSSE FLOSSE.libxsd

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxslt/libxslt-1.1.28-r1.ebuild,v 1.19 2015/04/08 17:51:55 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit autotools eutils python-r1 toolchain-funcs

DESCRIPTION="XSLT libraries and tools"
HOMEPAGE="http://www.xmlsoft.org/"
SRC_URI="ftp://xmlsoft.org/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="crypt debug python static-libs"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/libxml2-2.8.0:2
	crypt?  ( >=dev-libs/libgcrypt-1.1.42:0= )
	python? (
		${PYTHON_DEPS}
		dev-libs/libxml2:2[python,${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}"

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=684621
	epatch "${FILESDIR}"/${PN}.m4-${PN}-1.1.26.patch

	epatch "${FILESDIR}"/${PN}-1.1.26-disable_static_modules.patch

	# Python bindings are built/tested/installed manually.
	epatch "${FILESDIR}"/${PN}-1.1.28-manual-python.patch

	eautoreconf
	# If eautoreconf'd with new autoconf, then epunt_cxx is not necessary
	# and it is propably otherwise too if upstream generated with new
	# autoconf
#	epunt_cxx
}

src_configure() {
	# libgcrypt is missing pkg-config file, so fixing cross-compile
	# here. see bug 267503.
	tc-is-cross-compiler && \
		export LIBGCRYPT_CONFIG="${SYSROOT}"/usr/bin/libgcrypt-config

	econf \
		$(use_enable static-libs static) \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-html-subdir=html \
		$(use_with crypt crypto) \
		$(use_with python) \
		$(use_with debug) \
		$(use_with debug mem-debug)
}

src_compile() {
	default
	if use python; then
		python_copy_sources
		python_foreach_impl libxslt_py_emake
	fi
}

src_test() {
	default
	use python && python_foreach_impl libxslt_py_emake test
}

src_install() {
	default
	dodoc FEATURES

	if use python; then
		python_foreach_impl libxslt_py_emake DESTDIR="${D}" install
		python_foreach_impl python_optimize
		mv "${ED}"/usr/share/doc/${PN}-python-${PV} "${ED}"/usr/share/doc/${PF}/python
	fi

	prune_libtool_files --modules
}

libxslt_py_emake() {
	pushd "${BUILD_DIR}/python" > /dev/null || die
	emake \
		PYTHON="${PYTHON}" \
		PYTHON_INCLUDES="${EPREFIX}/usr/include/${EPYTHON}" \
		PYTHON_LIBS="$(python-config --ldflags)" \
		PYTHON_SITE_PACKAGES="${EPREFIX}$(python_get_sitedir)" \
		pythondir="${EPREFIX}$(python_get_sitedir)" \
		PYTHON_VERSION=${EPYTHON/python} "$@"
	popd > /dev/null
}

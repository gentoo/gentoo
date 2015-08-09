# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit autotools eutils python-r1 toolchain-funcs multilib-minimal

DESCRIPTION="XSLT libraries and tools"
HOMEPAGE="http://www.xmlsoft.org/"
SRC_URI="ftp://xmlsoft.org/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="crypt debug python static-libs"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	crypt?  ( >=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}] )
	python? (
		${PYTHON_DEPS}
		dev-libs/libxml2:2[python,${PYTHON_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20131008-r20
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	DOCS=( AUTHORS ChangeLog FEATURES NEWS README TODO )

	# https://bugzilla.gnome.org/show_bug.cgi?id=684621
	epatch "${FILESDIR}"/${PN}.m4-${PN}-1.1.26.patch

	epatch "${FILESDIR}"/${PN}-1.1.26-disable_static_modules.patch

	# use AC_PATH_TOOL for libgcrypt-config for sane cross-compile and multilib support
	# https://bugzilla.gnome.org/show_bug.cgi?id=725635
	epatch "${FILESDIR}"/${PN}-1.1.28-libgcrypt-config.patch

	# Python bindings are built/tested/installed manually.
	epatch "${FILESDIR}"/${PN}-1.1.28-manual-python.patch

	eautoreconf
	# If eautoreconf'd with new autoconf, then epunt_cxx is not necessary
	# and it is propably otherwise too if upstream generated with new
	# autoconf
#	epunt_cxx
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf \
		$(use_enable static-libs static) \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-html-subdir=html \
		$(use_with crypt crypto) \
		$(multilib_is_native_abi && use_with python || echo --without-python) \
		$(use_with debug) \
		$(use_with debug mem-debug)
}

multilib_src_compile() {
	default
	if use python && multilib_is_native_abi; then
		python_copy_sources
		python_foreach_impl libxslt_py_emake
	fi
}

multilib_src_test() {
	default
	use python && multilib_is_native_abi && python_foreach_impl libxslt_py_emake test
}

multilib_src_install() {
	# "default" does not work here - docs are installed by multilib_src_install_all
	emake DESTDIR="${D}" install

	if use python && multilib_is_native_abi; then
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

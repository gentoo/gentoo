# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
PYTHON_REQ_USE="xml"

inherit libtool flag-o-matic eutils python-r1 autotools prefix multilib-minimal

DESCRIPTION="Version 2 of the library to manipulate XML files"
HOMEPAGE="http://www.xmlsoft.org/"

LICENSE="MIT"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="debug examples icu ipv6 lzma python readline static-libs test"

XSTS_HOME="http://www.w3.org/XML/2004/xml-schema-test-suite"
XSTS_NAME_1="xmlschema2002-01-16"
XSTS_NAME_2="xmlschema2004-01-14"
XSTS_TARBALL_1="xsts-2002-01-16.tar.gz"
XSTS_TARBALL_2="xsts-2004-01-14.tar.gz"
XMLCONF_TARBALL="xmlts20080827.tar.gz"

SRC_URI="ftp://xmlsoft.org/${PN}/${PN}-${PV/_rc/-rc}.tar.gz
	test? (
		${XSTS_HOME}/${XSTS_NAME_1}/${XSTS_TARBALL_1}
		${XSTS_HOME}/${XSTS_NAME_2}/${XSTS_TARBALL_2}
		http://www.w3.org/XML/Test/${XMLCONF_TARBALL} )"

COMMON_DEPEND="
	>=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	icu? ( >=dev-libs/icu-51.2-r1:=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1:=[${MULTILIB_USEDEP}] )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:= )
"
RDEPEND="${COMMON_DEPEND}
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20131008-r6
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )
"
DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
	hppa? ( >=sys-devel/binutils-2.15.92.0.2 )
"

S="${WORKDIR}/${PN}-${PV%_rc*}"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/xml2-config
)

src_unpack() {
	# ${A} isn't used to avoid unpacking of test tarballs into $WORKDIR,
	# as they are needed as tarballs in ${S}/xstc instead and not unpacked
	unpack ${P/_rc/-rc}.tar.gz
	cd "${S}"

	if use test; then
		cp "${DISTDIR}/${XSTS_TARBALL_1}" \
			"${DISTDIR}/${XSTS_TARBALL_2}" \
			"${S}"/xstc/ \
			|| die "Failed to install test tarballs"
		unpack ${XMLCONF_TARBALL}
	fi
}

src_prepare() {
	DOCS=( AUTHORS ChangeLog NEWS README* TODO* )

	# Patches needed for prefix support
	epatch "${FILESDIR}"/${PN}-2.7.1-catalog_path.patch

	eprefixify catalog.c xmlcatalog.c runtest.c xmllint.c

	# Fix build for Windows platform
	epatch "${FILESDIR}"/${PN}-2.8.0_rc1-winnt.patch

	# Disable programs that we don't actually install.
	epatch "${FILESDIR}"/${PN}-2.9.2-disable-tests.patch

	# Fix zlib parameter handling for cross-compilation
	# https://bugzilla.gnome.org/show_bug.cgi?id=749416
	epatch "${FILESDIR}"/${PN}-2.9.2-cross-compile.patch

	# Use pkgconfig to find icu to properly support multilib
	# https://bugs.gentoo.org/show_bug.cgi?id=738751
	epatch "${FILESDIR}"/${PN}-2.9.2-icu-pkgconfig.patch

	# Important patches from master
	epatch \
		"${FILESDIR}"/${PN}-2.9.2-revert-missing-initialization.patch \
		"${FILESDIR}"/${PN}-2.9.2-missing-entities.patch \
		"${FILESDIR}"/${PN}-2.9.2-threads-declarations.patch \
		"${FILESDIR}"/${PN}-2.9.2-timsort.patch \
		"${FILESDIR}"/${PN}-2.9.2-cve-2015-7941-1.patch \
		"${FILESDIR}"/${PN}-2.9.2-cve-2015-7941-2.patch \
		"${FILESDIR}"/${PN}-2.9.2-constant-memory.patch \
		"${FILESDIR}"/${PN}-2.9.2-overflow-conditional-sections-1.patch	\
		"${FILESDIR}"/${PN}-2.9.2-overflow-conditional-sections-2.patch	\
		"${FILESDIR}"/${PN}-2.9.2-unclosed-comments.patch \
		"${FILESDIR}"/${PN}-2.9.2-cve-2015-8035.patch \
		"${FILESDIR}"/${PN}-2.9.2-fix-lzma.patch

	# Please do not remove, as else we get references to PORTAGE_TMPDIR
	# in /usr/lib/python?.?/site-packages/libxml2mod.la among things.
	# We now need to run eautoreconf at the end to prevent maintainer mode.
#	elibtoolize
#	epunt_cxx # if we don't eautoreconf

	eautoreconf
}

multilib_src_configure() {
	# filter seemingly problematic CFLAGS (#26320)
	filter-flags -fprefetch-loop-arrays -funroll-loops

	# USE zlib support breaks gnome2
	# (libgnomeprint for instance fails to compile with
	# fresh install, and existing) - <azarah@gentoo.org> (22 Dec 2002).

	# The meaning of the 'debug' USE flag does not apply to the --with-debug
	# switch (enabling the libxml2 debug module). See bug #100898.

	# --with-mem-debug causes unusual segmentation faults (bug #105120).

	libxml2_configure() {
		ECONF_SOURCE="${S}" econf \
			--with-html-subdir=${PF}/html \
			--docdir="${EPREFIX}/usr/share/doc/${PF}" \
			$(use_with debug run-debug) \
			$(use_with icu) \
			$(use_with lzma) \
			$(use_enable ipv6) \
			$(use_enable static-libs static) \
			$(multilib_native_use_with readline) \
			$(multilib_native_use_with readline history) \
			"$@"
	}

	libxml2_py_configure() {
		mkdir -p "${BUILD_DIR}" || die # ensure python build dirs exist
		run_in_build_dir libxml2_configure "--with-python=${PYTHON}" # odd build system
	}

	libxml2_configure --without-python # build python bindings separately

	if multilib_is_native_abi && use python; then
		python_foreach_impl libxml2_py_configure
	fi
}

multilib_src_compile() {
	default
	if multilib_is_native_abi && use python; then
		local native_builddir=${BUILD_DIR}
		python_foreach_impl libxml2_py_emake top_builddir="${native_builddir}" all
	fi
}

multilib_src_test() {
	default
	multilib_is_native_abi && use python && python_foreach_impl libxml2_py_emake test
}

multilib_src_install() {
	emake DESTDIR="${D}" \
		EXAMPLES_DIR="${EPREFIX}"/usr/share/doc/${PF}/examples install

	if multilib_is_native_abi && use python; then
		python_foreach_impl libxml2_py_emake \
			DESTDIR="${D}" \
			docsdir="${EPREFIX}"/usr/share/doc/${PF}/python \
			exampledir="${EPREFIX}"/usr/share/doc/${PF}/python/examples \
			install
		python_foreach_impl python_optimize
	fi
}

multilib_src_install_all() {
	# on windows, xmllint is installed by interix libxml2 in parent prefix.
	# this is the version to use. the native winnt version does not support
	# symlinks, which makes repoman fail if the portage tree is linked in
	# from another location (which is my default). -- mduft
	if [[ ${CHOST} == *-winnt* ]]; then
		rm -rf "${ED}"/usr/bin/xmllint
		rm -rf "${ED}"/usr/bin/xmlcatalog
	fi

	rm -rf "${ED}"/usr/share/doc/${P}
	einstalldocs

	if ! use examples; then
		rm -rf "${ED}"/usr/share/doc/${PF}/examples
		rm -rf "${ED}"/usr/share/doc/${PF}/python/examples
	fi

	prune_libtool_files --modules
}

pkg_postinst() {
	# We don't want to do the xmlcatalog during stage1, as xmlcatalog will not
	# be in / and stage1 builds to ROOT=/tmp/stage1root. This fixes bug #208887.
	if [[ "${ROOT}" != "/" ]]; then
		elog "Skipping XML catalog creation for stage building (bug #208887)."
	else
		# need an XML catalog, so no-one writes to a non-existent one
		CATALOG="${EROOT}etc/xml/catalog"

		# we dont want to clobber an existing catalog though,
		# only ensure that one is there
		# <obz@gentoo.org>
		if [[ ! -e ${CATALOG} ]]; then
			[[ -d "${EROOT}etc/xml" ]] || mkdir -p "${EROOT}etc/xml"
			"${EPREFIX}"/usr/bin/xmlcatalog --create > "${CATALOG}"
			einfo "Created XML catalog in ${CATALOG}"
		fi
	fi
}

libxml2_py_emake() {
	pushd "${BUILD_DIR}/python" > /dev/null || die
	emake "$@"
	popd > /dev/null
}

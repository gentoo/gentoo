# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
PYTHON_REQ_USE="xml"

inherit libtool flag-o-matic python-r1 autotools prefix multilib-minimal

DESCRIPTION="XML C parser and toolkit"
HOMEPAGE="http://www.xmlsoft.org/"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug examples icu ipv6 lzma +python readline static-libs test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

XSTS_HOME="http://www.w3.org/XML/2004/xml-schema-test-suite"
XSTS_NAME_1="xmlschema2002-01-16"
XSTS_NAME_2="xmlschema2004-01-14"
XSTS_TARBALL_1="xsts-2002-01-16.tar.gz"
XSTS_TARBALL_2="xsts-2004-01-14.tar.gz"
XMLCONF_TARBALL="xmlts20080827.tar.gz"

SRC_URI="ftp://xmlsoft.org/${PN}/${PN}-${PV/_rc/-rc}.tar.gz
	https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz
	test? (
		${XSTS_HOME}/${XSTS_NAME_1}/${XSTS_TARBALL_1}
		${XSTS_HOME}/${XSTS_NAME_2}/${XSTS_TARBALL_2}
		http://www.w3.org/XML/Test/${XMLCONF_TARBALL} )"

RDEPEND="
	>=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	icu? ( >=dev-libs/icu-51.2-r1:=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1:=[${MULTILIB_USEDEP}] )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:= )
"
DEPEND="${RDEPEND}
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
	unpack ${P}-patchset.tar.xz
	cd "${S}" || die

	if use test; then
		cp "${DISTDIR}/${XSTS_TARBALL_1}" \
			"${DISTDIR}/${XSTS_TARBALL_2}" \
			"${S}"/xstc/ \
			|| die "Failed to install test tarballs"
		unpack ${XMLCONF_TARBALL}
	fi
}

src_prepare() {
	default

	DOCS=( AUTHORS ChangeLog NEWS README* TODO* )

	# Selective cherry-picks from master up to 2019-02-28 (commit 8161b463f5)
	eapply "${WORKDIR}"/patches

	# Patches needed for prefix support
	eapply "${FILESDIR}"/${PN}-2.7.1-catalog_path.patch

	eprefixify catalog.c xmlcatalog.c runtest.c xmllint.c

	# Fix build for Windows platform
	# https://bugzilla.gnome.org/show_bug.cgi?id=760456
	# eapply "${FILESDIR}"/${PN}-2.8.0_rc1-winnt.patch

	# Fix python detection, bug #567066
	# https://bugzilla.gnome.org/show_bug.cgi?id=760458
	eapply "${FILESDIR}"/${PN}-2.9.2-python-ABIFLAG.patch

	# Fix python tests when building out of tree #565576
	eapply "${FILESDIR}"/${PN}-2.9.8-out-of-tree-test.patch

	# Workaround python3 itstool potential problems, bug 701020
	eapply "${FILESDIR}"/${PV}-python3-unicode-errors.patch

	if [[ ${CHOST} == *-darwin* ]] ; then
		# Avoid final linking arguments for python modules
		sed -i -e '/PYTHON_LIBS/s/ldflags/libs/' configure.ac || die
		# gcc-apple doesn't grok -Wno-array-bounds
		sed -i -e 's/-Wno-array-bounds//' configure.ac || die
	fi

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
		run_in_build_dir libxml2_configure \
			"--with-python=${EPYTHON}" \
			"--with-python-install-dir=$(python_get_sitedir)"
			# odd build system, also see bug #582130
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
	ln -s "${S}"/xmlconf || die
	emake check
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

	find "${D}" -name '*.la' -delete || die
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

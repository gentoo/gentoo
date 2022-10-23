# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: Please bump in sync with dev-libs/libxslt

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="xml(+)"
inherit flag-o-matic python-r1 multilib-minimal

XSTS_HOME="http://www.w3.org/XML/2004/xml-schema-test-suite"
XSTS_NAME_1="xmlschema2002-01-16"
XSTS_NAME_2="xmlschema2004-01-14"
XSTS_TARBALL_1="xsts-2002-01-16.tar.gz"
XSTS_TARBALL_2="xsts-2004-01-14.tar.gz"
XMLCONF_TARBALL="xmlts20130923.tar.gz"

DESCRIPTION="XML C parser and toolkit"
HOMEPAGE="http://www.xmlsoft.org/ https://gitlab.gnome.org/GNOME/libxml2"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/libxml2"
	inherit autotools git-r3
else
	inherit gnome.org libtool
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

SRC_URI+="
	test? (
		${XSTS_HOME}/${XSTS_NAME_1}/${XSTS_TARBALL_1}
		${XSTS_HOME}/${XSTS_NAME_2}/${XSTS_TARBALL_2}
		https://www.w3.org/XML/Test/${XMLCONF_TARBALL}
	)"
S="${WORKDIR}/${PN}-${PV%_rc*}"

LICENSE="MIT"
SLOT="2"
IUSE="debug examples +ftp icu lzma +python readline static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	icu? ( >=dev-libs/icu-51.2-r1:=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1:=[${MULTILIB_USEDEP}] )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

if [[ ${PV} == 9999 ]] ; then
	BDEPEND+=" dev-util/gtk-doc-am"
fi

MULTILIB_CHOST_TOOLS=(
	/usr/bin/xml2-config
)

DOCS=( NEWS README.md TODO TODO_SCHEMAS python/TODO )

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	else
		local tarname=${P/_rc/-rc}.tar.xz

		# ${A} isn't used to avoid unpacking of test tarballs into ${WORKDIR},
		# as they are needed as tarballs in ${S}/xstc instead and not unpacked
		unpack ${tarname}

		if [[ -n ${PATCHSET_VERSION} ]] ; then
			unpack ${PN}-${PATCHSET_VERSION}.tar.bz2
		fi
	fi

	cd "${S}" || die

	if use test ; then
		cp "${DISTDIR}/${XSTS_TARBALL_1}" \
			"${DISTDIR}/${XSTS_TARBALL_2}" \
			"${S}"/xstc/ \
			|| die "Failed to install test tarballs"
		unpack ${XMLCONF_TARBALL}
	fi
}

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		eautoreconf
	else
		# Please do not remove, as else we get references to PORTAGE_TMPDIR
		# in /usr/lib/python?.?/site-packages/libxml2mod.la among things.
		elibtoolize
	fi
}

multilib_src_configure() {
	# Filter seemingly problematic CFLAGS (bug #26320)
	filter-flags -fprefetch-loop-arrays -funroll-loops

	# Notes:
	# The meaning of the 'debug' USE flag does not apply to the --with-debug
	# switch (enabling the libxml2 debug module). See bug #100898.
	libxml2_configure() {
		ECONF_SOURCE="${S}" econf \
			--enable-ipv6 \
			$(use_with ftp) \
			$(use_with debug run-debug) \
			$(use_with icu) \
			$(use_with lzma) \
			$(use_enable static-libs static) \
			$(multilib_native_use_with readline) \
			$(multilib_native_use_with readline history) \
			"$@"
	}

	# Build python bindings separately
	libxml2_configure --without-python

	multilib_is_native_abi && use python &&
		python_foreach_impl run_in_build_dir libxml2_configure --with-python
}

libxml2_py_emake() {
	pushd "${BUILD_DIR}"/python >/dev/null || die

	emake top_builddir="${NATIVE_BUILD_DIR}" "$@"

	popd >/dev/null || die
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use python ; then
		NATIVE_BUILD_DIR="${BUILD_DIR}"
		python_foreach_impl run_in_build_dir libxml2_py_emake all
	fi
}

multilib_src_test() {
	ln -s "${S}"/xmlconf || die

	emake check

	multilib_is_native_abi && use python &&
		python_foreach_impl run_in_build_dir libxml2_py_emake check
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	multilib_is_native_abi && use python &&
		python_foreach_impl run_in_build_dir libxml2_py_emake DESTDIR="${D}" install

	# Hack until automake release is made for the optimise fix
	# https://git.savannah.gnu.org/cgit/automake.git/commit/?id=bde43d0481ff540418271ac37012a574a4fcf097
	multilib_is_native_abi && use python && python_foreach_impl python_optimize
}

multilib_src_install_all() {
	einstalldocs

	if ! use examples ; then
		rm -rf "${ED}"/usr/share/doc/${PF}/examples || die
		rm -rf "${ED}"/usr/share/doc/${PF}/python/examples || die
	fi

	rm -rf "${ED}"/usr/share/doc/${PN}-python-${PVR} || die

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	# We don't want to do the xmlcatalog during stage1, as xmlcatalog will not
	# be in / and stage1 builds to ROOT=/tmp/stage1root. This fixes bug #208887.
	if [[ -n "${ROOT}" ]]; then
		elog "Skipping XML catalog creation for stage building (bug #208887)."
	else
		# Need an XML catalog, so no-one writes to a non-existent one
		CATALOG="${EROOT}/etc/xml/catalog"

		# We don't want to clobber an existing catalog though,
		# only ensure that one is there
		# <obz@gentoo.org>
		if [[ ! -e "${CATALOG}" ]]; then
			[[ -d "${EROOT}/etc/xml" ]] || mkdir -p "${EROOT}/etc/xml"
			"${EPREFIX}"/usr/bin/xmlcatalog --create > "${CATALOG}"
			einfo "Created XML catalog in ${CATALOG}"
		fi
	fi
}

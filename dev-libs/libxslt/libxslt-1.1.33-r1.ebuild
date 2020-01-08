# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit autotools ltprune python-r1 toolchain-funcs multilib-minimal

DESCRIPTION="XSLT libraries and tools"
HOMEPAGE="http://www.xmlsoft.org/"
SRC_URI="ftp://xmlsoft.org/${PN}/${P}.tar.gz
		https://gitlab.gnome.org/GNOME/libxslt/commit/e03553605b45c88f0b4b2980adfbbb8f6fca2fd6.patch -> libxslt-1.1.33-CVE-2019-11068.patch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="crypt debug examples python static-libs elibc_Darwin"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/libxml2-2.9.1-r5:2[${MULTILIB_USEDEP}]
	crypt?  ( >=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}] )
	python? (
		${PYTHON_DEPS}
		dev-libs/libxml2:2[python,${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/xslt-config
)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libxslt/xsltconfig.h
)

src_prepare() {
	default

	DOCS=( AUTHORS ChangeLog FEATURES NEWS README TODO )

	# Simplify python setup
	# https://bugzilla.gnome.org/show_bug.cgi?id=758095
	eapply "${FILESDIR}"/1.1.32-simplify-python.patch
	eapply "${FILESDIR}"/${PN}-1.1.28-disable-static-modules.patch
	eapply "${DISTDIR}"/libxslt-1.1.33-CVE-2019-11068.patch

	eautoreconf
	# If eautoreconf'd with new autoconf, then epunt_cxx is not necessary
	# and it is propably otherwise too if upstream generated with new
	# autoconf
#	epunt_cxx
	# But Prefix always needs elibtoolize if not eautoreconf'd.
#	elibtoolize
}

multilib_src_configure() {
	libxslt_configure() {
		ECONF_SOURCE="${S}" econf \
			--with-html-dir="${EPREFIX}"/usr/share/doc/${PF} \
			--with-html-subdir=html \
			$(use_with crypt crypto) \
			$(use_with debug) \
			$(use_with debug mem-debug) \
			$(use_enable static-libs static) \
			"$@"
	}

	libxslt_py_configure() {
		mkdir -p "${BUILD_DIR}" || die # ensure python build dirs exist
		run_in_build_dir libxslt_configure --with-python
	}

	libxslt_configure --without-python # build python bindings separately

	if multilib_is_native_abi && use python; then
		python_foreach_impl libxslt_py_configure
	fi
}

multilib_src_compile() {
	default
	multilib_is_native_abi && use python && libxslt_foreach_py_emake all
}

multilib_src_test() {
	default
	multilib_is_native_abi && use python && libxslt_foreach_py_emake test
}

multilib_src_install() {
	# "default" does not work here - docs are installed by multilib_src_install_all
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use python; then
		libxslt_foreach_py_emake \
			DESTDIR="${D}" \
			docsdir="${EPREFIX}"/usr/share/doc/${PF}/python \
			EXAMPLE_DIR="${EPREFIX}"/usr/share/doc/${PF}/python/examples \
			install
		python_foreach_impl python_optimize
	fi
}

multilib_src_install_all() {
	einstalldocs

	if ! use examples && use python; then
		rm -r "${ED}"/usr/share/doc/${PF}/python/examples || die
	fi

	prune_libtool_files --modules
}

libxslt_foreach_py_emake() {
	libxslt_py_emake() {
		pushd "${BUILD_DIR}/python" > /dev/null || die
		emake "$@"
		popd > /dev/null
	}
	local native_builddir=${BUILD_DIR}
	python_foreach_impl libxslt_py_emake top_builddir="${native_builddir}" "$@"
}

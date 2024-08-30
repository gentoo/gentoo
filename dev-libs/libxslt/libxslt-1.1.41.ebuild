# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: Please bump this in sync with dev-libs/libxml2.

PYTHON_COMPAT=( python3_{10..13} )
inherit python-r1 multilib-minimal

DESCRIPTION="XSLT libraries and tools"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libxslt"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/libxslt"
	inherit autotools git-r3
else
	inherit libtool gnome.org
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

LICENSE="MIT"
SLOT="0"
IUSE="crypt debug examples python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND=">=virtual/pkgconfig-1"
RDEPEND="
	>=dev-libs/libxml2-2.13:2[${MULTILIB_USEDEP}]
	crypt? ( >=dev-libs/libgcrypt-1.5.3:=[${MULTILIB_USEDEP}] )
	python? (
		${PYTHON_DEPS}
		>=dev-libs/libxml2-2.13:2[${MULTILIB_USEDEP},python,${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/xslt-config
)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libxslt/xsltconfig.h
)

PATCHES=(
	"${FILESDIR}"/${P}-extensions-xmlCheckFilename-older-libxml2.patch
	"${FILESDIR}"/${P}-libxml2-2.13.patch
	"${FILESDIR}"/${P}-deprecated-xmlCharEncodingHandler.patch
)

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		eautoreconf
	else
		# Prefix always needs elibtoolize if not eautoreconf'd.
		elibtoolize
	fi
}

multilib_src_configure() {
	libxslt_configure() {
		ECONF_SOURCE="${S}" econf \
			--without-python \
			$(use_with crypt crypto) \
			$(use_with debug) \
			$(use_enable static-libs static) \
			"$@"
	}

	# Build Python bindings separately
	libxslt_configure --without-python

	if multilib_is_native_abi && use python ; then
		NATIVE_BUILD_DIR="${BUILD_DIR}"
		python_foreach_impl run_in_build_dir libxslt_configure --with-python
	fi
}

libxslt_py_emake() {
	pushd "${BUILD_DIR}"/python >/dev/null || die

	emake top_builddir="${NATIVE_BUILD_DIR}" "$@"

	popd >/dev/null || die
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use python ; then
		python_foreach_impl run_in_build_dir libxslt_py_emake all
	fi
}

multilib_src_test() {
	default

	if multilib_is_native_abi && use python ; then
		python_foreach_impl run_in_build_dir libxslt_py_emake check
	fi
}

multilib_src_install() {
	# "default" does not work here - docs are installed by multilib_src_install_all
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use python; then
		python_foreach_impl run_in_build_dir libxslt_py_emake \
			DESTDIR="${D}" \
			install

		# Hack until automake release is made for the optimise fix
		# https://git.savannah.gnu.org/cgit/automake.git/commit/?id=bde43d0481ff540418271ac37012a574a4fcf097
		python_foreach_impl python_optimize
	fi
}

multilib_src_install_all() {
	einstalldocs

	if ! use examples ; then
		rm -rf "${ED}"/usr/share/doc/${PF}/tutorial{,2} || die
		rm -rf "${ED}"/usr/share/doc/${PF}/python/examples || die
	fi

	find "${ED}" -type f -name "*.la" -delete || die
}

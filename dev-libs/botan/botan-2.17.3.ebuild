# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-r1 toolchain-funcs

MY_P="Botan-${PV}"

DESCRIPTION="C++ crypto library"
HOMEPAGE="https://botan.randombit.net/"
SRC_URI="https://botan.randombit.net/releases/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="2/$(ver_cut 1-2)" # soname version
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~sparc x86 ~ppc-macos"
IUSE="bindist doc boost bzip2 libressl lzma python ssl static-libs sqlite zlib"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	')
"

# NOTE: Boost is needed at runtime too for the CLI tool.
DEPEND="
	boost? ( >=dev-libs/boost-1.48:= )
	bzip2? ( >=app-arch/bzip2-1.0.5:= )
	lzma? ( app-arch/xz-utils:= )
	python? ( ${PYTHON_DEPS} )
	ssl? (
		!libressl? ( dev-libs/openssl:0=[bindist=] )
		libressl? ( dev-libs/libressl:0= )
	)
	sqlite? ( dev-db/sqlite:3= )
	zlib? ( >=sys-libs/zlib-1.2.3:= )
"

RDEPEND="${DEPEND}"

# NOTE: Considering patching Botan?
# Please see upstream's guidance:
# https://botan.randombit.net/handbook/packaging.html#minimize-distribution-patches

python_check_deps() {
	if use doc ; then
		has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]" || return 1
	fi
}

src_configure() {
	local disable_modules=()
	use boost || disable_modules+=( "boost" )
	use bindist && disable_modules+=( "ecdsa" )
	elog "Disabling module(s): ${disable_modules[@]}"

	# Enable v9 instructions for sparc64
	local chostarch="${CHOST%%-*}"
	if [[ "${PROFILE_ARCH}" = "sparc64" ]] ; then
		chostarch="sparc32-v9"
	fi

	local myos=
	case ${CHOST} in
		*-darwin*) myos=darwin ;;
		*) myos=linux  ;;
	esac

	case ${CHOST} in
		hppa*) chostarch=parisc ;;
	esac

	local pythonvers=()
	if use python ; then
		_append() {
			pythonvers+=( ${EPYTHON/python/} )
		}

		python_foreach_impl _append
	fi

	# Don't install Python bindings automatically
	# (do it manually later in the right place)
	# https://bugs.gentoo.org/723096
	local myargs=(
		$(use_enable static-libs static-library)
		$(use_with boost)
		$(use_with bzip2)
		$(use_with doc documentation)
		$(use_with doc sphinx)
		$(use_with lzma)
		$(use_with sqlite sqlite3)
		$(use_with ssl openssl)
		$(use_with zlib)
		$(usex hppa --without-stack-protector '')
		--cpu=${chostarch}
		--disable-modules=$( IFS=","; echo "${disable_modules[*]}" )
		--docdir=share/doc
		--libdir=$(get_libdir)
		--os=${myos}
		--distribution-info="Gentoo ${PVR}"
		--prefix="${EPREFIX}/usr"
		--with-endian="$(tc-endian)"
		--with-python-version=$( IFS=","; echo "${pythonvers[*]}" )
		--without-doxygen
		--no-install-python-module
	)

	tc-export CC CXX AR

	./configure.py "${myargs[@]}" || die "configure.py failed"
}

src_test() {
	LD_LIBRARY_PATH="${S}" ./botan-test || die "Validation tests failed"
}

src_install() {
	default

	# Manually install the Python bindings (bug #723096)
	if use python ; then
		python_foreach_impl python_domodule src/python/botan2.py
	fi
}

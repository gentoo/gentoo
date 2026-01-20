# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/botan.asc
inherit edo dot-a flag-o-matic multiprocessing ninja-utils python-r1 toolchain-funcs verify-sig

MY_P="Botan-${PV}"
DESCRIPTION="C++ crypto library"
HOMEPAGE="https://botan.randombit.net/"
SRC_URI="https://botan.randombit.net/releases/${MY_P}.tar.xz"
SRC_URI+=" verify-sig? ( https://botan.randombit.net/releases/${MY_P}.tar.xz.asc )"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
# New major versions are parallel-installable
SLOT="$(ver_cut 1)/$(ver_cut 1-2)" # soname version
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="doc boost bzip2 lzma python static-libs sqlite test tools zlib"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# NOTE: Boost is needed at runtime too for the CLI tool.
DEPEND="
	boost? ( dev-libs/boost:= )
	bzip2? ( >=app-arch/bzip2-1.0.5:= )
	lzma? ( app-arch/xz-utils:= )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( dev-db/sqlite:3= )
	zlib? ( >=virtual/zlib-1.2.3:= )
"
RDEPEND="
	${DEPEND}
	!<dev-libs/botan-2.19.3-r1:2[tools]
"
BDEPEND="
	${PYTHON_DEPS}
	${NINJA_DEPEND}
	$(python_gen_any_dep '
		doc? (
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/furo[${PYTHON_USEDEP}]
		)
	')
	|| ( >=sys-devel/gcc-11:* >=llvm-core/clang-14:* )
	verify-sig? ( sec-keys/openpgp-keys-botan )
"

# NOTE: Considering patching Botan?
# Please see upstream's guidance:
# https://botan.randombit.net/handbook/packaging.html#minimize-distribution-patches

PATCHES=(
	"${FILESDIR}"/${PN}-3.9.0-tests-simd.patch
)

python_check_deps() {
	use doc || return 0
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/furo[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	[[ ${MERGE_TYPE} == binary ]] && return

	# bug #908958
	tc-check-min_ver gcc 11
	tc-check-min_ver clang 14
}

src_configure() {
	tc-export AR CC CXX
	use static-libs && lto-guarantee-fat
	python_setup

	local disable_modules=(
		$(usev !boost 'boost')
	)

	if [[ -z "${DISABLE_MODULES}" ]] ; then
		elog "Disabling module(s): ${disable_modules[@]}"
	fi

	local chostarch="${CHOST%%-*}"

	# Arch specific wrangling
	local myos=
	case ${CHOST} in
		*-darwin*)
			myos=darwin
			;;
		*)
			myos=linux

			if [[ ${CHOST} == *hppa* ]] ; then
				chostarch=parisc
			elif [[ ${ABI} == sparc64 ]] ; then
				chostarch="sparc64"
			elif [[ ${ABI} == sparc32 ]] ; then
				chostarch="sparc32"
			fi
			;;
	esac

	local pythonvers=()
	if use python ; then
		_append() {
			pythonvers+=( ${EPYTHON/python/} )
		}

		python_foreach_impl _append
	fi

	local myargs=(
		# We already set this by default in the toolchain
		--without-stack-protector

		$(use_with boost)
		$(use_with bzip2)
		$(use_with doc documentation)
		$(use_with doc sphinx)
		$(use_with lzma)
		$(use_enable static-libs static-library)
		$(use_with sqlite sqlite3)
		$(use_with zlib)

		--build-tool=ninja
		--cpu=${chostarch}
		--docdir=share/doc
		--disable-modules=$(IFS=","; echo "${disable_modules[*]}")
		--distribution-info="Gentoo ${PVR}"
		--libdir="$(get_libdir)"
		# Avoid collisions between slots for tools (bug #905700)
		--program-suffix=$(ver_cut 1)

		# Don't install Python bindings automatically
		# (do it manually later in the right place)
		# bug #723096
		--no-install-python-module

		--os=${myos}
		--prefix="${EPREFIX}"/usr
		--lto-cxxflags-to-ldflags
		--with-python-version=$(IFS=","; echo "${pythonvers[*]}")
	)

	local build_targets=(
		shared
		$(usev static-libs static)
		$(usev tools cli)
		$(usev test tests)
	)

	myargs+=(
		--build-targets=$(IFS=","; echo "${build_targets[*]}")
	)

	if ( use elibc_glibc || use elibc_musl ) && use kernel_linux ; then
		myargs+=(
			--with-os-features=getrandom,getentropy
		)
	fi

	local sanitizers=()
	if is-flagq -fsanitize=address ; then
		sanitizers+=( address )
	fi
	if is-flagq -fsanitize=undefined ; then
		sanitizers+=( undefined )
	fi
	filter-flags '-fsanitize=*'
	myargs+=(
		--enable-sanitizers=$(IFS=","; echo "${sanitizers[*]}")
	)

	edo ${EPYTHON} configure.py --verbose "${myargs[@]}"
}

src_compile() {
	eninja
}

src_test() {
	LD_LIBRARY_PATH="${S}" edo ./botan-test$(ver_cut 1) --test-threads="$(makeopts_jobs)"
}

src_install() {
	DESTDIR="${D}" eninja install

	strip-lto-bytecode

	if [[ -d "${ED}"/usr/share/doc/${P} && ${P} != ${PF} ]] ; then
		# --docdir in configure controls the parent directory unfortunately
		mv "${ED}"/usr/share/doc/${P} "${ED}"/usr/share/doc/${PF} || die
	fi

	if [[ -d "${ED}"/usr/share/man/man1 ]] ; then
		# --program-suffix doesn't apply to the man page
		mv "${ED}"/usr/share/man/man1/botan{,$(ver_cut 1)}.1 || die
	fi

	# Manually install the Python bindings (bug #723096)
	if use python ; then
		python_foreach_impl python_domodule src/python/botan$(ver_cut 1).py
	fi
}

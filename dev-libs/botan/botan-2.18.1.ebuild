# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/botan.asc"
inherit python-r1 toolchain-funcs verify-sig

MY_P="Botan-${PV}"
DESCRIPTION="C++ crypto library"
HOMEPAGE="https://botan.randombit.net/"
SRC_URI="https://botan.randombit.net/releases/${MY_P}.tar.xz"
SRC_URI+=" verify-sig? ( https://botan.randombit.net/releases/${MY_P}.tar.xz.asc )"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="2/$(ver_cut 1-2)" # soname version
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~ppc-macos"
IUSE="bindist doc boost bzip2 lzma python ssl static-libs sqlite zlib"

CPU_USE=(
	cpu_flags_arm_{aes,neon}
	cpu_flags_ppc_altivec
	cpu_flags_x86_{aes,avx2,popcnt,rdrand,sse2,ssse3,sse4_1,sse4_2}
)

IUSE+=" ${CPU_USE[@]}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# NOTE: Boost is needed at runtime too for the CLI tool.
DEPEND="
	boost? ( >=dev-libs/boost-1.48:= )
	bzip2? ( >=app-arch/bzip2-1.0.5:= )
	lzma? ( app-arch/xz-utils:= )
	python? ( ${PYTHON_DEPS} )
	ssl? ( dev-libs/openssl:0=[bindist=] )
	sqlite? ( dev-db/sqlite:3= )
	zlib? ( >=sys-libs/zlib-1.2.3:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	')
	verify-sig? ( app-crypt/openpgp-keys-botan )
"

# NOTE: Considering patching Botan?
# Please see upstream's guidance:
# https://botan.randombit.net/handbook/packaging.html#minimize-distribution-patches

python_check_deps() {
	if use doc ; then
		has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]" || return 1
	fi
}

src_configure() {
	local disable_modules=(
		$(usex boost '' 'boost')
		$(usex bindist 'ecdsa' '')
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
			elif [[ ${PROFILE_ARCH} == "sparc64" ]] ; then
				chostarch="sparc32-v9"
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
		# Intrinsics
		# TODO: x86 RDSEED (new CPU_FLAGS_X86?)
		# TODO: POWER Crypto (new CPU_FLAGS_PPC?)
		$(usex cpu_flags_arm_aes '' '--disable-armv8crypto')
		$(usex cpu_flags_arm_neon '' '--disable-neon')
		$(usex cpu_flags_ppc_altivec '' '--disable-altivec')
		$(usex cpu_flags_x86_aes '' '--disable-aes-ni')
		$(usex cpu_flags_x86_avx2 '' '--disable-avx2')
		$(usex cpu_flags_x86_popcnt '' '--disable-bmi2')
		$(usex cpu_flags_x86_rdrand '' '--disable-rdrand')
		$(usex cpu_flags_x86_sse2 '' '--disable-sse2')
		$(usex cpu_flags_x86_ssse3 '' '--disable-ssse3')
		$(usex cpu_flags_x86_sse4_1 '' '--disable-sse4.1')
		$(usex cpu_flags_x86_sse4_2 '' '--disable-sse4.2')

		$(usex hppa --without-stack-protector '')

		$(use_with boost)
		$(use_with bzip2)
		$(use_with doc documentation)
		$(use_with doc sphinx)
		$(use_with lzma)
		$(use_enable static-libs static-library)
		$(use_with ssl openssl)
		$(use_with sqlite sqlite3)
		$(use_with zlib)

		--cpu=${chostarch}
		--docdir=share/doc
		--disable-modules=$( IFS=","; echo "${disable_modules[*]}" )
		--distribution-info="Gentoo ${PVR}"
		--libdir=$(get_libdir)

		# Don't install Python bindings automatically
		# (do it manually later in the right place)
		# https://bugs.gentoo.org/723096
		--no-install-python-module

		--os=${myos}
		--prefix="${EPREFIX}/usr"
		--with-endian="$(tc-endian)"
		--with-python-version=$( IFS=","; echo "${pythonvers[*]}" )
		--without-doxygen
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

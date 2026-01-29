# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# to make make a crosscompiler use crossdev and symlink ghc tree into
# cross overlay. result would look like 'cross-sparc-unknown-linux-gnu/ghc'
export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} = ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

PYTHON_COMPAT=( python3_{9..14} )
LLVM_COMPAT=( {15..20} )

inherit python-any-r1
inherit autotools bash-completion-r1 flag-o-matic ghc-package
inherit toolchain-funcs prefix check-reqs llvm-r2 unpacker haskell-cabal verify-sig

DESCRIPTION="The Glasgow Haskell Compiler"
HOMEPAGE="https://www.haskell.org/ghc/"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/ghc.asc

GHC_BRANCH_COMMIT="a3401159f2846605abb517e71af463df47398e72" # ghc-9.8.4-release

GHC_BINARY_PV="9.6.2"
SRC_URI="
	https://downloads.haskell.org/~ghc/${PV}/${P}-src.tar.xz
	verify-sig? ( https://downloads.haskell.org/~ghc/${PV}/${P}-src.tar.xz.sig )
	!ghcbootstrap? (
		https://downloads.haskell.org/~ghc/9.8.2/hadrian-bootstrap-sources/hadrian-bootstrap-sources-${GHC_BINARY_PV}.tar.gz
		amd64? ( https://downloads.haskell.org/~ghc/${GHC_BINARY_PV}/ghc-${GHC_BINARY_PV}-x86_64-alpine3_12-linux-static-int_native.tar.xz )
		arm64? ( elibc_glibc? (
			https://downloads.haskell.org/~ghc/${GHC_BINARY_PV}/ghc-${GHC_BINARY_PV}-aarch64-deb10-linux.tar.xz
		) )
	)
	test? (
		https://gitlab.haskell.org/ghc/ghc/-/archive/${GHC_BRANCH_COMMIT}.tar.gz
			-> ${PN}-${GHC_BRANCH_COMMIT}.tar.gz
	)
"

GHC_BUGGY_TESTS=(
	# Actual stderr output differs from expected:
	# +/usr/libexec/gcc/x86_64-pc-linux-gnu/ld: warning: ManySections.o: missing .note.GNU-stack section implies executable stack
	# +/usr/libexec/gcc/x86_64-pc-linux-gnu/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
	"testsuite/tests/driver/recomp015"
)

yet_binary() {
	case ${ARCH} in
		amd64)
			return 0
			;;
		arm64)
			case "${ELIBC}" in
				glibc)
					return 0
					;;
				*)
					return 1
					;;
			esac
			;;
		*)
			return 1
			;;
	esac
}

# We are using the upstream static Alpine Linux binaries to bootstrap some
# archs. These binaries have different properties than the ones we build
# ourselves, so we need a way to check to see if they are in use.
upstream_binary() {
	case ${ARCH} in
		amd64)
			return 0
			;;
		arm64)
			case "${ELIBC}" in
				glibc)
					return 0
					;;
				*)
					return 1
					;;
			esac
			;;
		*)
			return 1
			;;
	esac
}

# The location of the unpacked Alpine Linux tarball
ghc_bin_path() {
	local ghc_bin_triple
	case ${ARCH} in
		amd64)
			ghc_bin_triple="x86_64-unknown-linux"
			;;
		arm64)
			if use elibc_musl; then
				ghc_bin_triple="aarch64-alpine-linux"
			else
				ghc_bin_triple="aarch64-unknown-linux"
			fi
			;;
		*)
			die "Unknown ghc binary triple. The list here should match yet_binary."
			;;
	esac

	echo "${WORKDIR}/ghc-${GHC_BINARY_PV}-${ghc_bin_triple}"
}

GHC_PV=${PV}
#GHC_PV=8.10.0.20200123 # uncomment only for -alpha, -beta, -rc ebuilds
GHC_P=${PN}-${GHC_PV} # using ${P} is almost never correct

S="${WORKDIR}"/${GHC_P}

BUMP_LIBRARIES=(
	# "hackage-name          hackage-version"
	#Match 9.6.7
	"directory 1.3.9.0"
	"file-io 0.1.5"
)

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64"
IUSE="big-endian doc elfutils ghcbootstrap ghcmakebinary +gmp llvm numa profile test unregisterised"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/perl-5.6.1
	dev-libs/gmp:0=
	dev-libs/libffi:=
	sys-libs/ncurses:=[unicode(+)]
	elfutils? ( dev-libs/elfutils )
	numa? ( sys-process/numactl )
	llvm? (
		$(llvm_gen_dep '
			llvm-core/clang:${LLVM_SLOT}=
			llvm-core/llvm:${LLVM_SLOT}=
		')
	)
"

DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.2
		app-text/docbook-xml-dtd:4.5
		app-text/docbook-xsl-stylesheets
		dev-python/sphinx
		>=dev-libs/libxslt-1.1.2
	)
	ghcbootstrap? (
		ghcmakebinary? ( dev-haskell/hadrian[static] )
		>=dev-haskell/hadrian-9.8.4-r1 <dev-haskell/hadrian-9.8.4-r9999
	)
	test? (
		${PYTHON_DEPS}
		${LLVM_DEPS}
	)
	verify-sig? (
		sec-keys/openpgp-keys-ghc
	)
"

needs_python() {
	# test driver is written in python
	use test && return 0
	return 1
}

# we build binaries without profiling support
REQUIRED_USE="
	?? ( llvm unregisterised )
"

# haskell libraries built with cabal in configure mode, #515354
QA_CONFIGURE_OPTIONS+=" --with-compiler --with-gcc"

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

is_native() {
	[[ ${CHOST} == ${CBUILD} ]] && [[ ${CHOST} == ${CTARGET} ]]
}

if ! is_crosscompile; then
	PDEPEND="!ghcbootstrap? ( >=app-admin/haskell-updater-1.2 )"
fi

# returns tool prefix for crosscompiler.
# Example:
#  CTARGET=armv7a-unknown-linux-gnueabi
#  CHOST=x86_64-pc-linux-gnu
#    "armv7a-unknown-linux-gnueabi-"
#  CTARGET=${CHOST}
#    ""
# Used in tools and library prefix:
#    "${ED}"/usr/bin/$(cross)haddock
#    "${ED}/usr/$(get_libdir)/$(cross)${GHC_P}/package.conf.d"

cross() {
	if is_crosscompile; then
		echo "${CTARGET}-"
	else
		echo ""
	fi
}

append-ghc-cflags() {
	local persistent compile assemble link
	local flag ghcflag

	for flag in $*; do
		case ${flag} in
			persistent)	persistent="yes";;
			compile)	compile="yes";;
			assemble)	assemble="yes";;
			link)		link="yes";;
			*)
				[[ ${compile}  ]] && ghcflag="-optc${flag}"  CFLAGS+=" ${flag}" && GHC_FLAGS+=" ${ghcflag}" &&
					[[ ${persistent} ]] && GHC_PERSISTENT_FLAGS+=" ${ghcflag}"
				[[ ${assemble} ]] && ghcflag="-opta${flag}"  CFLAGS+=" ${flag}" && GHC_FLAGS+=" ${ghcflag}" &&
					[[ ${persistent} ]] && GHC_PERSISTENT_FLAGS+=" ${ghcflag}"
				[[ ${link}     ]] && ghcflag="-optl${flag}" LDFLAGS+=" ${flag}" && GHC_FLAGS+=" ${ghcflag}" &&
					[[ ${persistent} ]] && GHC_PERSISTENT_FLAGS+=" ${ghcflag}"
				;;
		esac
	done
}

# $1 - directory
# $2 - lib name
# $3 - lib version
# example: bump_lib "libraries" "transformers" "0.4.2.0"
bump_lib() {
	local dir="$1" pn=$2 pv=$3
	local p=${pn}-${pv}
	local f

	einfo "Bumping ${pn} up to ${pv}"

	if [[ -d "${dir}"/"${pn}" ]] # if the library exists already, move it out of the way
	then
		mv "${dir}"/"${pn}" "${WORKDIR}"/"${pn}".old || die
	fi
	mv "${WORKDIR}"/"${p}" "${dir}"/"${pn}" || die
}

update_SRC_URI() {
	local p pn pv
	for p in "${BUMP_LIBRARIES[@]}"; do
		set -- $p
		pn=$1 pv=$2

		SRC_URI+=" https://hackage.haskell.org/package/${pn}-${pv}/${pn}-${pv}.tar.gz"
	done
}

update_SRC_URI

bump_libs() {
	local p pn pv dir
	for p in "${BUMP_LIBRARIES[@]}"; do
		set -- $p
		pn=$1 pv=$2

		if [[ "$pn" == "Cabal-syntax" ]] || [[ "$pn" == "Cabal" ]]; then
			dir="libraries/Cabal"
		else
			dir="libraries"
		fi

		bump_lib "${dir}" "${pn}" "${pv}"
	done
}

ghc_setup_toolchain() {
	tc-export CC CXX LD AR RANLIB
	einfo "ghc_setup_toolchain: CC=${CC} CXX=${CXX} LD=${LD} AR=${AR} RANLIB=${RANLIB}"
}

ghc_setup_cflags() {
	# TODO: plumb CFLAGS and BUILD_CFLAGS to respective CONF_CC_OPTS_STAGE<N>
	if ! is_native; then
		export CFLAGS=${GHC_CFLAGS-"-O2 -pipe"}
		export LDFLAGS=${GHC_LDFLAGS-"-Wl,-O1"}
		einfo "Crosscompiling mode:"
		einfo "   CHOST:   ${CHOST}"
		einfo "   CTARGET: ${CTARGET}"
		einfo "   CFLAGS:  ${CFLAGS}"
		einfo "   LDFLAGS: ${LDFLAGS}"
		einfo "   prefix: $(cross)"
		return
	fi
	# We need to be very careful with the CFLAGS we ask ghc to pass through to
	# gcc. There are plenty of flags which will make gcc produce output that
	# breaks ghc in various ways. The main ones we want to pass through are
	# -mcpu / -march flags. These are important for arches like alpha & sparc.
	# We also use these CFLAGS for building the C parts of ghc, ie the rts.
	strip-flags
	strip-unsupported-flags

	# Cmm can't parse line numbers #482086
	replace-flags -ggdb[3-9] -ggdb2

	GHC_FLAGS=""
	GHC_PERSISTENT_FLAGS=""
	for flag in ${CFLAGS}; do
		case ${flag} in

			# Ignore extra optimisation (ghc passes -O to gcc anyway)
			# -O2 and above break on too many systems
			-O*) ;;

			# Arch and ABI flags are what we're really after
			-m*) append-ghc-cflags compile assemble ${flag};;

			# Sometimes it's handy to see backtrace of RTS
			# to get an idea what happens there
			-g*) append-ghc-cflags compile ${flag};;

			# Ignore all other flags, including all -f* flags
		esac
	done

	for flag in ${LDFLAGS}; do
		append-ghc-cflags link ${flag}
	done
}

# substitutes string $1 to $2 in files $3 $4 ...
relocate_path() {
	local from=$1
	local   to=$2
	shift 2
	local file=
	for file in "$@"
	do
		sed -i -e "s|$from|$to|g" \
			"$file" || die "path relocation failed for '$file'"
	done
}

# changes hardcoded ghc paths and updates package index
# $1 - new absolute root path
relocate_ghc() {
	local to=$1 ghc_v=${BIN_PV}

	# libdir for prebuilt binary and for current system may mismatch
	# It does for prefix installation for example: bug #476998
	local bin_ghc_prefix=${WORKDIR}/usr
	local bin_libpath=$(echo "${bin_ghc_prefix}"/lib*)
	local bin_libdir=${bin_libpath#${bin_ghc_prefix}/}

	# backup original script to use it later after relocation
	local gp_back="${T}/ghc-pkg-${ghc_v}-orig"
	cp "${WORKDIR}/usr/bin/ghc-pkg-${ghc_v}" "$gp_back" || die "unable to backup ghc-pkg wrapper"

	if [[ ${bin_libdir} != $(get_libdir) ]]; then
		einfo "Relocating '${bin_libdir}' to '$(get_libdir)' (bug #476998)"
		# moving the dir itself is not strictly needed
		# but then USE=binary would result in installing
		# in '${bin_libdir}'
		mv "${bin_ghc_prefix}/${bin_libdir}" "${bin_ghc_prefix}/$(get_libdir)" || die

		relocate_path "/usr/${bin_libdir}" "/usr/$(get_libdir)" \
			"${WORKDIR}/usr/bin/ghc-${ghc_v}" \
			"${WORKDIR}/usr/bin/ghci-${ghc_v}" \
			"${WORKDIR}/usr/bin/ghc-pkg-${ghc_v}" \
			"${WORKDIR}/usr/bin/hsc2hs" \
			"${WORKDIR}/usr/bin/runghc-${ghc_v}" \
			"$gp_back" \
			"${WORKDIR}/usr/$(get_libdir)/${PN}-${ghc_v}/lib/package.conf.d/"*
	fi

	# Relocate from /usr to ${EPREFIX}/usr
	relocate_path "/usr" "${to}/usr" \
		"${WORKDIR}/usr/bin/ghc-${ghc_v}" \
		"${WORKDIR}/usr/bin/ghci-${ghc_v}" \
		"${WORKDIR}/usr/bin/ghc-pkg-${ghc_v}" \
		"${WORKDIR}/usr/bin/haddock-ghc-${ghc_v}" \
		"${WORKDIR}/usr/bin/hp2ps" \
		"${WORKDIR}/usr/bin/hpc" \
		"${WORKDIR}/usr/bin/hsc2hs" \
		"${WORKDIR}/usr/bin/runghc-${ghc_v}" \
		"${WORKDIR}/usr/$(get_libdir)/${PN}-${ghc_v}/lib/package.conf.d/"*

	# this one we will use to regenerate cache
	# so it should point to current tree location
	relocate_path "/usr" "${WORKDIR}/usr" "$gp_back"

	if use prefix; then
		hprefixify "${bin_libpath}"/${PN}*/settings
	fi

	# regenerate the binary package cache
	"$gp_back" recache || die "failed to update cache after relocation"
	rm "$gp_back"
}

ghc-check-reqs() {
	# These are pessimistic values (slightly bigger than worst-case)
	# Worst case is UNREG USE=profile ia64. See bug #611866 for some
	# numbers on various arches.
	CHECKREQS_DISK_BUILD=20G
	CHECKREQS_DISK_USR=4G

	"$@"
}

ghc-check-bootstrap-version () {
	local diemsg version
	ebegin "Checking for appropriate installed GHC version for bootstrapping"
	if version=$(ghc-version); then
		if ver_test "${version}" -gt "9.0.0"; then
			eend 0
			return 0
		else
			diemsg="Inappropriate GHC version for bootstrapping: ${version}"
		fi
	else
		diemsg="Could not find installed GHC for bootstrapping"
	fi

	eend 1
	eerror "USE=ghcbootstrap _requires_ an existing GHC already installed on the system."
	eerror "Furthermore, the hadrian build system requires that the existing ghc be"
	eerror "version 9.0 or higher."
	die "$diemsg"
}

ghc-check-bootstrap-mismatch () {
	local diemsg ghc_version cabal_version
	ebegin "Checking for mismatched GHC and Cabal versions for bootstrapping"
	if ver_test "$(ghc-version)" -lt "9.4" && ver_test "$(cabal-version)" -gt "3.8"; then
		eend 1
		eerror "There have been issues bootstrapping ghc-9.4 with <ghc-9.4 and >Cabal-3.8"
		eerror "Please install dev-haskell/cabal-3.6.* instead first."
		die "Mismatched GHC and Cabal versions for bootstrapping"
	else
		eend 0
	fi
}

# TODO: Break out into hadrian.eclass
# Uses $_hadrian_args, if set
run_hadrian() {
	if use ghcbootstrap; then
		local cmd=("${BROOT}/usr/bin/hadrian")
	else
		local cmd=("${S}/hadrian/bootstrap/_build/bin/hadrian")
	fi

	cmd+=( "${_hadrian_args[@]}" "$@" )

	einfo "Running: ${cmd[@]}"
	"${cmd[@]}" || die
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use ghcbootstrap; then
		ghc-check-bootstrap-version
		ghc-check-bootstrap-mismatch
	fi
	ghc-check-reqs check-reqs_pkg_pretend
}

pkg_setup() {
	ghc-check-reqs check-reqs_pkg_setup

	[[ ${MERGE_TYPE} == binary ]] && return

	if use ghcbootstrap; then
		ewarn "You requested ghc bootstrapping, this is usually only used"
		ewarn "by Gentoo developers to make binary .tbz2 packages."

		[[ -z $(type -P ghc) ]] && \
			die "Could not find a ghc to bootstrap with."
	else
		if ! yet_binary; then
			eerror "Please try emerging with USE=ghcbootstrap and report build"
			eerror "success or failure to the haskell team (haskell@gentoo.org)"
			die "No binary available for '${ARCH}' arch yet, USE=ghcbootstrap"
		fi
	fi

	if needs_python; then
		python-any-r1_pkg_setup
	fi

	use llvm && llvm-r2_pkg_setup
}

src_unpack() {
	# the Solaris and Darwin binaries from ghc (maeder) need to be
	# unpacked separately, so prevent them from being unpacked
	local ONLYA=${A}
	case ${CHOST} in
		*-darwin* | *-solaris*)  ONLYA=${GHC_P}-src.tar.xz  ;;
	esac
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}-src.tar.xz{,.sig}
	fi
	# Strip signature files from the list of files to unpack
	for f in ${ONLYA}; do
		if [[ ${f} != *.sig ]]; then
			nosig="${nosig} ${f}"
		fi
	done
	unpacker ${nosig}
}

src_prepare() {
	# Force the use of C.utf8 locale
	# <https://github.com/gentoo-haskell/gentoo-haskell/issues/1287>
	# <https://github.com/gentoo-haskell/gentoo-haskell/issues/1289>
	export LC_ALL=C.utf8

	ghc_setup_toolchain
	ghc_setup_cflags

	if ! use ghcbootstrap && ! upstream_binary; then
		# Make GHC's settings file comply with user's settings
		GHC_SETTINGS="$(ghc_bin_path)/lib/settings"

		sed -i "s/,(\"C compiler command\", \".*\")/,(\"C compiler command\", \"${CC}\")/" "${GHC_SETTINGS}" || die
		sed -i "s/,(\"C++ compiler command\", \".*\")/,(\"C++ compiler command\", \"${CXX}\")/" "${GHC_SETTINGS}" || die
		sed -i "s/,(\"Haskell CPP command\", \".*\")/,(\"Haskell CPP command\", \"${CC}\")/" "${GHC_SETTINGS}" || die
		sed -i "s/,(\"ld command\", \".*\")/,(\"ld command\", \"${LD}\")/" "${GHC_SETTINGS}" || die
		sed -i "s/,(\"Merge objects command\", \".*\")/,(\"Merge objects command\", \"${LD}\")/" "${GHC_SETTINGS}" || die
		sed -i "s/,(\"ar command\", \".*\")/,(\"ar command\", \"${AR}\")/" "${GHC_SETTINGS}" || die
		sed -i "s/,(\"ranlib command\", \".*\")/,(\"ranlib command\", \"${RANLIB}\")/" "${GHC_SETTINGS}" || die
	fi

	# binpkg may have been built with FEATURES=splitdebug
	if [[ -d "${WORKDIR}/usr/lib/debug" ]] ; then
		rm -rf "${WORKDIR}/usr/lib/debug" || die
	fi
	find "${WORKDIR}/usr/lib" -type d -empty -delete 2>/dev/null # do not die on failure here

	# ffi headers don't get included in the binpkg for some reason
	for f in "${WORKDIR}/usr/$(get_libdir)/${PN}-${BIN_PV}/include/"{ffi.h,ffitarget.h}
	do
		mkdir -p "$(dirname "${f}")"
		[[ -e "${f}" ]] || ln -sf "$($(tc-getPKG_CONFIG) --cflags-only-I libffi | sed "s/-I//g" | tr -d " ")/$(basename "${f}")" "${f}" || die
	done

	if ! use ghcbootstrap && ! upstream_binary; then
		relocate_ghc "${WORKDIR}"
	fi

	sed -i -e "s|\"\$topdir\"|\"\$topdir\" ${GHC_PERSISTENT_FLAGS}|" \
		"${S}/ghc/ghc.wrapper"

	# Incorrectly assumes modern Alex uses -v as an alias for --version
	sed -i -e 's/\(fptools_cv_alex_version=`"$AlexCmd" \)-v/\1--version/' \
		"${S}/m4/fptools_alex.m4" || die

	# Release tarball does not contain needed test data
	if use test; then
		cp -a "${WORKDIR}/${PN}-${GHC_BRANCH_COMMIT}/testsuite" "${S}" || die

		[[ ${#GHC_BUGGY_TESTS[@]} -gt 0 ]] && einfo "Tests have been marked as buggy and will be deleted:"

		local t

		for t in "${GHC_BUGGY_TESTS[@]}"; do
			einfo "     * ${t}"
		done

		for t in "${GHC_BUGGY_TESTS[@]}"; do
			rm -r "${S}/${t}" || die
		done
	fi

	cd "${S}" # otherwise eapply will break

	eapply "${FILESDIR}"/${PN}-8.10.1-allow-cross-bootstrap.patch

	# https://gitlab.haskell.org/ghc/ghc/-/issues/22954
	# https://gitlab.haskell.org/ghc/ghc/-/issues/21936
	eapply "${FILESDIR}"/${PN}-9.6.4-llvm-20.patch

	# Fix issue caused by non-standard "musleabi" target in
	# https://gitlab.haskell.org/ghc/ghc/-/blob/ghc-9.4.5-release/m4/ghc_llvm_target.m4#L39
	eapply "${FILESDIR}"/${PN}-9.4.5-musl-target.patch

	# Fix QA Notice: Found the following implicit function declarations in configure logs
	eapply "${FILESDIR}/${PN}-9.10.1-fix-configure-implicit-function.patch"

	pushd "${S}/hadrian" || die
		# Fix QA Notice: Unrecognized configure options: --with-cc
		eapply "${FILESDIR}/hadrian-9.4.8-remove-with-cc-configure-flag.patch"
		# Fix QA Notice: One or more compressed files were found in docompress-ed directories
		eapply "${FILESDIR}/hadrian-9.4.8-disable-doc-archives.patch"
		# Add support for file-io
		eapply "${FILESDIR}/hadrian-9.8.4-add-packages.patch"
	popd

	# mingw32 target
	pushd "${S}/libraries/Win32"
		eapply "${FILESDIR}"/${PN}-8.2.1_rc1-win32-cross-2-hack.patch # bad workaround
	popd

	# Only applies to the testsuite directory copied from the git snapshot
	if use test; then
		eapply "${FILESDIR}/${PN}-9.8.2-fix-ipe-test.patch"
		eapply "${FILESDIR}/${PN}-9.8.2-fix-buggy-tests.patch"
	fi

	# <https://github.com/gentoo-haskell/gentoo-haskell/issues/1579>
	eapply "${FILESDIR}/${PN}-9.8.4-add-missing-rts-include.patch"

	# <https://github.com/gentoo-haskell/gentoo-haskell/issues/1775>
	# <https://gitlab.haskell.org/ghc/ghc/-/issues/25662>
	eapply "${FILESDIR}/${PN}-9.12.2-hp2ps-c23-compat.patch"

	bump_libs

	eapply_user
	# as we have changed the build system
	eautoreconf
}

src_configure() {
	### Gather the arguments we will pass to Hadrian:

	# Create an array of arguments for hadrian, which will be used internally by
	# run_hadrian() (so don't set this as local)
	_hadrian_args=()

	# Could be added/tested at some later point
	_hadrian_args+=("--docs=no-sphinx-pdfs")

	# Any non-native build has to skip as it needs
	# target haddock binary to be runnable.
	if ! use doc || ! is_native; then
		_hadrian_args+=(
			"--docs=no-sphinx-html"
			# this controls presence on 'xhtml' and 'haddock' in final install
			# !is_native: disable docs generation as it requires running stage2
			"--docs=no-haddocks"
		)
	fi

	use doc || _hadrian_args+=( "--docs=no-sphinx-man" )

	###
	# TODO: Move these env vars to a hadrian eclass, for better
	# documentation and clarity
	###

	# Control the build flavour
	local hadrian_flavour="default" f
	use profile || hadrian_flavour+="+no_profiled_libs"
	use llvm && hadrian_flavour+="+llvm"

	# Enable production of native debugging information (via GHC/GCC's `-g3`)
	# during stage1+ compilations. (Toggled via detecting -g* in CFLAGS)
	for f in $CFLAGS; do
		case $f in
			-g*) hadrian_flavour+="+debug_info"; break ;;
		esac
	done

	: ${HADRIAN_FLAVOUR:="${hadrian_flavour}"}

	_hadrian_args+=("--flavour=${HADRIAN_FLAVOUR}")

	# Control the verbosity of hadrian. Default is one level of --verbose
	: ${HADRIAN_VERBOSITY:=1}

	local n="${HADRIAN_VERBOSITY}"
	until [[ $n -le 0 ]]; do
		_hadrian_args+=("--verbose")
		n=$(($n - 1 ))
	done

	# Add any -j* flags passed in via $MAKEOPTS
	for i in $MAKEOPTS; do
		case $i in
			-j*) _hadrian_args+=("$i") ;;
			*) true ;;
		esac
	done



	### Prepare hadrian build settings files

	mkdir _build
	touch _build/hadrian.settings

	# We also need to use the GHC_FLAGS flags when building ghc itself
	echo "*.*.ghc.hs.opts += ${GHC_FLAGS}" >> _build/hadrian.settings
	echo "*.*.ghc.c.opts += ${GHC_FLAGS}" >> _build/hadrian.settings

	# Don't let it pre-strip the stage 1 bootstrapping libraries (which will be
	# installed to the system)
	echo "stage1.*.cabal.configure.opts += --disable-library-stripping" >> _build/hadrian.settings

    ### Gather configuration variables for GHC

	# Get ghc from the binary
	# except when bootstrapping we just pick ghc up off the path
	if ! use ghcbootstrap; then
		export PATH="${WORKDIR}/ghc-bin/$(get_libdir)/ghc-${GHC_BINARY_PV}/bin:${PATH}"
	fi

	local econf_args=()

	# GHC embeds toolchain it was built by and uses it later.
	# Don't allow things like ccache or versioned binary slip.
	# We use stable thing across gcc upgrades.
	# User can use EXTRA_ECONF=CC=... to override this default.
	econf_args+=(
		# these should be inferred by GHC but ghc defaults
		# to using bundled tools on windows.
		Windres=${CTARGET}-windres
		DllWrap=${CTARGET}-dllwrap
		# we set the linker explicitly below
		--disable-ld-override

		# Put docs into the right place, ie /usr/share/doc/ghc-${GHC_PV}
		--docdir="${EPREFIX}/usr/share/doc/$(cross)${PF}"

		# Use system libffi instead of bundled libffi-tarballs
		--with-system-libffi
		--with-ffi-includes=$($(tc-getPKG_CONFIG) --cflags-only-I libffi | sed 's/-I//g')
	)

	if [[ ${CBUILD} != ${CHOST} ]]; then
		# GHC bug: ghc claims not to support cross-building.
		# It does, but does not distinct --host= value
		# for stage1 and stage2 compiler.
		econf_args+=(--host=${CBUILD})
	fi

	if use ghcmakebinary; then
		# When building booting libary we are trying to
		# bundle or restrict most of external depends
		# with unstable ABI:
		#  - embed libffi (default GHC behaviour)
		#  - disable ncurses support for ghci (via haskeline)
		#    https://bugs.gentoo.org/557478
		#  - disable ncurses support for ghc-pkg
		echo "*.haskeline.cabal.configure.opts += --flag=-terminfo" >> _build/hadrian.settings
		echo "*.ghc-pkg.cabal.configure.opts += --flag=-terminfo" >> _build/hadrian.settings
	fi

	# User-supplied block to be added to hadrian.settings
	echo "${HADRIAN_SETTINGS_EXTRA}" >> _build/hadrian.settings

	einfo "Final _build/hadrian.settings:"
	cat _build/hadrian.settings || die




	### Bootstrap Hadrian, then final configure (should this be here or in src_compile?)

	if ! use ghcbootstrap; then
		einfo "Installing bootstrap GHC"

		( cd "$(ghc_bin_path)" || die
			econf "${econf_args[@]}" \
				--prefix="" \
				--libdir="/$(get_libdir)" || die
			emake DESTDIR="${WORKDIR}/ghc-bin" install
		)

		einfo "Bootstrapping hadrian"
		( cd "${S}/hadrian/bootstrap" || die
			./bootstrap.py \
				-w "${WORKDIR}/ghc-bin/$(get_libdir)/ghc-${GHC_BINARY_PV}/bin/ghc" \
				-s "${DISTDIR}/hadrian-bootstrap-sources-${GHC_BINARY_PV}.tar.gz" || die "Hadrian bootstrap failed"
		)
	fi

#		--enable-bootstrap-with-devel-snapshot \
	econf ${econf_args[@]} \
		$(use_enable elfutils dwarf-unwind) \
		$(use_enable numa) \
		$(use_enable unregisterised)

	if [[ ${PV} == *9999* ]]; then
		GHC_PV="$(grep 'S\[\"PACKAGE_VERSION\"\]' config.status | sed -e 's@^.*=\"\(.*\)\"@\1@')"
		GHC_P=${PN}-${GHC_PV}
	fi
}

src_compile() {

	run_hadrian binary-dist-dir

	# FIXME: This is failing, but the docs mention it:
	# <https://gitlab.haskell.org/hololeap/ghc/-/blob/master/hadrian/doc/testsuite.md?ref_type=heads#building-just-the-dependencies-needed-for-the-testsuite>
	# >    Error, file does not exist and no rule available:
	# >    test:all_deps
	#
	#use test && run_hadrian test:all_deps
}

src_test() {

	# Make sure stage 1 libraries are available
	for d in "${S}/work/${P}/_build/stage1/lib"/*${P}/*/; do
		export LD_LIBRARY_PATH="${d}${LD_LIBRARY_PATH:+:}${LD_LIBRARY_PATH}"
	done

	local args=(
		--progress-info=unicorn # good luck unicorns
	)

	run_hadrian "${args[@]}" test
}

src_install() {
	local package_confdir="${ED}/usr/$(get_libdir)/$(cross)${GHC_P}/lib/package.conf.d"

	[[ -f VERSION ]] || emake VERSION

	pushd "${S}/_build/bindist/${P}-${CHOST}" || die
	econf
	emake DESTDIR="${D}" install
	popd

	# Skip for cross-targets as they all share target location:
	# /usr/share/doc/ghc-9999/
	if ! is_crosscompile; then
		dodoc "distrib/README" "LICENSE" "VERSION"
	fi

	# rename ghc-shipped files to avoid collision
	# of external packages. Motivating example:
	#  user had installed:
	#      dev-lang/ghc-7.8.4-r0 (with transformers-0.3.0.0)
	#      dev-haskell/transformers-0.4.2.0
	#  then user tried to update to
	#      dev-lang/ghc-7.8.4-r1 (with transformers-0.4.2.0)
	#  this will lead to single .conf file collision.
	local shipped_conf renamed_conf
	for shipped_conf in "${package_confdir}"/*.conf; do
		# rename 'pkg-ver-id.conf' to 'pkg-ver-id-gentoo-${PF}.conf'
		renamed_conf=${shipped_conf%.conf}-gentoo-${PF}.conf
		mv "${shipped_conf}" "${renamed_conf}" || die
	done

	# remove link, but leave 'haddock-${GHC_P}'
	rm -f "${ED}"/usr/bin/$(cross)haddock

	if ! is_crosscompile; then
		newbashcomp "${FILESDIR}"/ghc-bash-completion ghc-pkg
		newbashcomp utils/completion/ghc.bash         ghc
	fi

	# path to the package.cache
	PKGCACHE="${package_confdir}"/package.cache
	# copy the package.conf.d, including timestamp, save it so we can help
	# users that have a broken package.conf.d
	cp -pR "${package_confdir}"{,.initial} || die "failed to backup initial package.conf.d"

	# copy the package.conf, including timestamp, save it so we later can put it
	# back before uninstalling, or when upgrading.
	cp -p "${PKGCACHE}"{,.shipped} \
		|| die "failed to copy package.conf.d/package.cache"

	if is_crosscompile; then
		# When we build a cross-compiler the layout is the following:
		#     usr/lib/${CTARGET}-ghc-${VER}/ contains target libraries
		# but
		#     usr/lib/${CTARGET}-ghc-${VER}/bin/ directory
		# containst host binaries (modulo bugs).

		# Portage's stripping mechanism does not skip stripping
		# foreign binaries. This frequently causes binaries to be
		# broken.
		#
		# Thus below we disable stripping of target libraries and allow
		# stripping hosts executables.
		dostrip -x "/usr/$(get_libdir)/$(cross)${GHC_P}"
		dostrip    "/usr/$(get_libdir)/$(cross)${GHC_P}/bin"
	fi
}

pkg_preinst() {
	# have we got an earlier version of ghc installed?
	if has_version "<${CATEGORY}/${PF}"; then
		haskell_updater_warn="1"
	fi
}

pkg_postinst() {
	ghc-reregister

	# path to the package.cache
	PKGCACHE="${EROOT}/usr/$(get_libdir)/$(cross)${GHC_P}/lib/package.conf.d/package.cache"

	# give the cache a new timestamp, it must be as recent as
	# the package.conf.d directory.
	touch "${PKGCACHE}"

	if [[ "${haskell_updater_warn}" == "1" ]]; then
		ewarn
		ewarn "\e[1;31m************************************************************************\e[0m"
		ewarn
		ewarn "You have just upgraded from an older version of GHC."
		ewarn "You may have to run"
		ewarn "      'haskell-updater'"
		ewarn "to rebuild all ghc-based Haskell libraries."
		ewarn
		ewarn "\e[1;31m************************************************************************\e[0m"
		ewarn
	fi
}

pkg_prerm() {
	PKGCACHE="${EROOT}/usr/$(get_libdir)/$(cross)${GHC_P}/lib/package.conf.d/package.cache"
	rm -rf "${PKGCACHE}"

	cp -p "${PKGCACHE}"{.shipped,}
}

pkg_postrm() {
	ghc-package_pkg_postrm
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: haskell-cabal.eclass
# @MAINTAINER:
# Haskell herd <haskell@gentoo.org>
# @AUTHOR:
# Original author: Andres Loeh <kosmikus@gentoo.org>
# Original author: Duncan Coutts <dcoutts@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: for packages that make use of the Haskell Common Architecture for Building Applications and Libraries (cabal)
# @DESCRIPTION:
# Basic instructions:
#
# Before inheriting the eclass, set CABAL_FEATURES to
# reflect the tools and features that the package makes
# use of.
#
# Currently supported features:
#   haddock    --  for documentation generation
#   hscolour   --  generation of colourised sources
#   hoogle     --  generation of documentation search index
#   profile    --  if package supports to build profiling-enabled libraries
#   bootstrap  --  only used for the cabal package itself
#   lib        --  the package installs libraries
#   nocabaldep --  don't add dependency on cabal.
#                  only used for packages that _must_ not pull the dependency
#                  on cabal, but still use this eclass (e.g. haskell-updater).
#   ghcdeps    --  constraint dependency on package to ghc onces
#                  only used for packages that use libghc internally and _must_
#                  not pull upper versions
#   test-suite --  add support for cabal test-suites (introduced in Cabal-1.8)
#   rebuild-after-doc-workaround -- enable doctest test failue workaround.
#                  Symptom: when `./setup haddock` is run in a `build-type: Custom`
#                  package it might cause cause the test-suite to fail with
#                  errors like:
#                  > <command line>: cannot satisfy -package-id singletons-2.7-3Z7pnljD8tU1NrslJodXmr
#                  Workaround re-reginsters the package to avoid the failure
#                  (and rebuilds changes).
#                  FEATURE can be removed once https://github.com/haskell/cabal/issues/7213
#                  is fixed.

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_HASKELL_CABAL_ECLASS} ]]; then
_HASKELL_CABAL_ECLASS=1

[[ ${EAPI} == 6 ]] && inherit eqawarn

inherit ghc-package multilib toolchain-funcs

# @ECLASS_VARIABLE: CABAL_EXTRA_CONFIGURE_FLAGS
# @USER_VARIABLE
# @DESCRIPTION:
# User-specified additional parameters passed to 'setup configure'.
# example: /etc/portage/make.conf:
#    CABAL_EXTRA_CONFIGURE_FLAGS="--enable-shared --enable-executable-dynamic"
: ${CABAL_EXTRA_CONFIGURE_FLAGS:=}

# @ECLASS_VARIABLE: CABAL_EXTRA_BUILD_FLAGS
# @USER_VARIABLE
# @DESCRIPTION:
# User-specified additional parameters passed to 'setup build'.
# example: /etc/portage/make.conf: CABAL_EXTRA_BUILD_FLAGS=-v
: ${CABAL_EXTRA_BUILD_FLAGS:=}

# @ECLASS_VARIABLE: GHC_BOOTSTRAP_FLAGS
# @USER_VARIABLE
# @DESCRIPTION:
# User-specified additional parameters for ghc when building
# _only_ 'setup' binary bootstrap.
# example: /etc/portage/make.conf: GHC_BOOTSTRAP_FLAGS=-dynamic to make
# linking 'setup' faster.
: ${GHC_BOOTSTRAP_FLAGS:=}

# @ECLASS_VARIABLE: CABAL_EXTRA_HADDOCK_FLAGS
# @USER_VARIABLE
# @DESCRIPTION:
# User-specified additional parameters passed to 'setup haddock'.
# example: /etc/portage/make.conf:
#    CABAL_EXTRA_HADDOCK_FLAGS="--haddock-options=--latex --haddock-options=--pretty-html"
: ${CABAL_EXTRA_HADDOCK_FLAGS:=}

# @ECLASS_VARIABLE: CABAL_EXTRA_HOOGLE_FLAGS
# @USER_VARIABLE
# @DESCRIPTION:
# User-specified additional parameters passed to 'setup haddock --hoogle'.
# example: /etc/portage/make.conf:
#    CABAL_EXTRA_HOOGLE_FLAGS="--haddock-options=--show-all"
: ${CABAL_EXTRA_HOOGLE_FLAGS:=}

# @ECLASS_VARIABLE: CABAL_EXTRA_HSCOLOUR_FLAGS
# @USER_VARIABLE
# @DESCRIPTION:
# User-specified additional parameters passed to 'setup hscolour'.
# example: /etc/portage/make.conf:
#    CABAL_EXTRA_HSCOLOUR_FLAGS="--executables --tests"
: ${CABAL_EXTRA_HSCOLOUR_FLAGS:=}


# @ECLASS_VARIABLE: CABAL_EXTRA_TEST_FLAGS
# @USER_VARIABLE
# @DESCRIPTION:
# User-specified additional parameters passed to 'setup test'.
# example: /etc/portage/make.conf:
#    CABAL_EXTRA_TEST_FLAGS="-v3 --show-details=streaming"
: ${CABAL_EXTRA_TEST_FLAGS:=}

# @ECLASS_VARIABLE: CABAL_DEBUG_LOOSENING
# @DESCRIPTION:
# Show debug output for 'cabal_chdeps' function if set.
# Needs working 'diff'.
: ${CABAL_DEBUG_LOOSENING:=}

# @ECLASS_VARIABLE: CABAL_REPORT_OTHER_BROKEN_PACKAGES
# @DESCRIPTION:
# Show other broken packages if 'cabal configure' fails.
# It should be normally enabled unless you know you are about
# to try to compile a lot of broken packages. Default value: 'yes'
# Set to anything else to disable.
: ${CABAL_REPORT_OTHER_BROKEN_PACKAGES:=yes}

# @ECLASS_VARIABLE: CABAL_HACKAGE_REVISION
# @PRE_INHERIT
# @DESCRIPTION:
# Set the upstream revision number from Hackage. This will automatically
# add the upstream cabal revision to SRC_URI and apply it in src_prepare.
: ${CABAL_HACKAGE_REVISION:=0}

# @ECLASS_VARIABLE: CABAL_PN
# @PRE_INHERIT
# @DESCRIPTION:
# Set the name of the package as it is recorded in the Hackage database. This
# is mostly used when packages use CamelCase names upstream, but we want them
# to be lowercase in portage.
: ${CABAL_PN:=${PN}}

# @ECLASS_VARIABLE: CABAL_PV
# @PRE_INHERIT
# @DESCRIPTION:
# Set the version of the package as it is recorded in the Hackage database.
# This can be useful if we use a different versioning scheme in Portage than
# the one from upstream
: ${CABAL_PV:=${PV}}

# @ECLASS_VARIABLE: CABAL_P
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# The combined $CABAL_PN and $CABAL_PV variables, analogous to $P
CABAL_P="${CABAL_PN}-${CABAL_PV}"

S="${WORKDIR}/${CABAL_P}"

# @ECLASS_VARIABLE: CABAL_FILE
# @DESCRIPTION:
# The location of the .cabal file for the Haskell package. This defaults to
# "${S}/${CABAL_PN}.cabal".
: ${CABAL_FILE:="${S}/${CABAL_PN}.cabal"}

# @ECLASS_VARIABLE: CABAL_DISTFILE
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# The name of the .cabal file downloaded from Hackage. This filename does not
# include $DISTDIR
if [[ ${CABAL_HACKAGE_REVISION} -ge 1 ]]; then
	CABAL_DISTFILE="${P}-rev${CABAL_HACKAGE_REVISION}.cabal"
fi

# @ECLASS_VARIABLE: CABAL_CHDEPS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specifies changes to be made to the .cabal file. Uses the cabal_chdeps
# function internally and shares the same syntax.
# @EXAMPLE:
# CABAL_CHDEPS=(
#    'base >= 4.2 && < 4.6' 'base >= 4.2 && < 4.7'
#    'containers ==0.4.*' 'containers >= 0.4 && < 0.6'
# )
: ${CABAL_CHDEPS:=}

# @ECLASS_VARIABLE: CABAL_LIVE_VERSION
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this to any value to prevent SRC_URI from being set automatically.
: ${CABAL_LIVE_VERSION:=}

# @ECLASS_VARIABLE: GHC_BOOTSTRAP_PACKAGES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Extra packages that need to be exposed when compiling Setup.hs
# @EXAMPLE:
# GHC_BOOTSTRAP_PACKAGES=(
#	cabal-doctest
# )
: ${GHC_BOOTSTRAP_PACKAGES:=}

# 'dev-haskell/cabal' passes those options with ./configure-based
# configuration, but most packages don't need/don't accept it:
# #515362, #515362
QA_CONFIGURE_OPTIONS+=" --with-compiler --with-hc --with-hc-pkg --with-gcc"

for feature in ${CABAL_FEATURES}; do
	case ${feature} in
		haddock)    CABAL_USE_HADDOCK=yes;;
		hscolour)   CABAL_USE_HSCOLOUR=yes;;
		hoogle)     CABAL_USE_HOOGLE=yes;;
		profile)    CABAL_USE_PROFILE=yes;;
		bootstrap)  CABAL_BOOTSTRAP=yes;;
		lib)        CABAL_HAS_LIBRARIES=yes;;
		nocabaldep) CABAL_FROM_GHC=yes;;
		ghcdeps)    CABAL_GHC_CONSTRAINT=yes;;
		test-suite) CABAL_TEST_SUITE=yes;;
		rebuild-after-doc-workaround) CABAL_REBUILD_AFTER_DOC_WORKAROUND=yes;;

		*) CABAL_UNKNOWN="${CABAL_UNKNOWN} ${feature}";;
	esac
done

if [[ -n "${CABAL_USE_HADDOCK}" ]]; then
	IUSE="${IUSE} doc"
fi

if [[ -n "${CABAL_USE_HSCOLOUR}" ]]; then
	IUSE="${IUSE} hscolour"
	DEPEND="${DEPEND} hscolour? ( dev-haskell/hscolour )"
fi

if [[ -n "${CABAL_USE_HOOGLE}" ]]; then
	# enabled only in ::haskell
	# IUSE="${IUSE} hoogle"
	CABAL_USE_HOOGLE=
fi

if [[ -n "${CABAL_USE_PROFILE}" ]]; then
	IUSE="${IUSE} profile"
fi

if [[ -n "${CABAL_TEST_SUITE}" ]]; then
	IUSE="${IUSE} test"
	RESTRICT+=" !test? ( test )"
fi

# If SRC_URI is defined in the ebuild without appending, it will overwrite
# the value set here. This will not be set on packages whose versions end in "9999"
# or if CABAL_LIVE_VERSION is set.
case $PV in
	*9999) ;;
	*)
		if [[ -z "${CABAL_LIVE_VERSION}" ]]; then
			if [[ "${CABAL_P}" == "${P}" ]]; then
				SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"
			else
				SRC_URI="https://hackage.haskell.org/package/${CABAL_P}/${CABAL_P}.tar.gz -> ${P}.tar.gz"
			fi
			if [[ -n ${CABAL_DISTFILE} ]]; then
				SRC_URI+=" https://hackage.haskell.org/package/${CABAL_P}/revision/${CABAL_HACKAGE_REVISION}.cabal -> ${CABAL_DISTFILE}"
			fi
		fi ;;
esac

BDEPEND="${BDEPEND} app-text/dos2unix"

# returns the version of cabal currently in use.
# Rarely it's handy to pin cabal version from outside.
: ${_CABAL_VERSION_CACHE:=""}
cabal-version() {
	if [[ -z "${_CABAL_VERSION_CACHE}" ]]; then
		if [[ "${CABAL_BOOTSTRAP}" ]]; then
			# We're bootstrapping cabal, so the cabal version is the version
			# of this package itself.
			_CABAL_VERSION_CACHE="${PV}"
		elif [[ "${CABAL_FROM_GHC}" ]]; then
			_CABAL_VERSION_CACHE="$(ghc-cabal-version)"
		else
			# We ask portage, not ghc, so that we only pick up
			# portage-installed cabal versions.
			_CABAL_VERSION_CACHE="$(ghc-extract-pm-version dev-haskell/cabal)"
			# exception for live (9999) version
			if [[ "${_CABAL_VERSION_CACHE}" == 9999 ]]; then
				_CABAL_VERSION_CACHE="$(ghc-cabal-version)"
			fi
		fi
	fi
	echo "${_CABAL_VERSION_CACHE}"
}

cabal-bootstrap() {
	local setupmodule
	local cabalpackage
	local setup_bootstrap_args=()

	if [[ -f "${S}/Setup.lhs" ]]; then
		setupmodule="${S}/Setup.lhs"
	elif [[ -f "${S}/Setup.hs" ]]; then
		setupmodule="${S}/Setup.hs"
	else
		eqawarn "No Setup.lhs or Setup.hs found. Either add Setup.hs to package or call cabal-mksetup from ebuild"
		cabal-mksetup
		setupmodule="${S}/Setup.hs"
	fi

	# We build the setup program using the latest version of
	# cabal that we have installed
	cabalpackage=Cabal-$(cabal-version)
	einfo "Using cabal-$(cabal-version)."

	if $(ghc-supports-threaded-runtime); then
		# Cabal has a bug that deadlocks non-threaded RTS:
		#     https://bugs.gentoo.org/537500
		#     https://github.com/haskell/cabal/issues/2398
		setup_bootstrap_args+=(-threaded)
	fi

	# The packages available when compiling Setup.hs need to be controlled,
	# otherwise module name collisions are possible.
	local -a bootstrap_pkg_args=(-hide-all-packages)

	# Expose common packages bundled with GHC
	# See: <https://gitlab.haskell.org/ghc/ghc/-/wikis/commentary/libraries/version-history>
	local default_exposed_pkgs="
		Cabal
		base
		binary
		bytestring
		containers
		deepseq
		directory
		exceptions
		filepath
		haskeline
		mtl
		parsec
		pretty
		process
		stm
		template-haskell
		terminfo
		text
		time
		transformers
		unix
		xhtml
	"

	for pkg in $default_exposed_pkgs ${GHC_BOOTSTRAP_PACKAGES[*]}; do
		bootstrap_pkg_args+=(-package "$pkg")
	done

	make_setup() {
		set -- "${bootstrap_pkg_args[@]}" --make "${setupmodule}" \
			$(ghc-make-args) \
			"${setup_bootstrap_args[@]}" \
			${HCFLAGS} \
			${GHC_BOOTSTRAP_FLAGS} \
			"$@" \
			-o setup
		echo $(ghc-getghc) "$@"
		$(ghc-getghc) "$@"
	}
	if $(ghc-supports-shared-libraries); then
		{ make_setup -dynamic "$@" && ./setup --help >/dev/null; } ||
		make_setup "$@" || die "compiling ${setupmodule} failed"
	else
		make_setup "$@" || die "compiling ${setupmodule} failed"
	fi
}

cabal-mksetup() {
	local setupdir=${1:-${S}}
	local setup_src=${setupdir}/Setup.hs

	rm -vf "${setupdir}"/Setup.{lhs,hs}
	elog "Creating 'Setup.hs' for 'Simple' build type."

	echo 'import Distribution.Simple; main = defaultMain' \
		> "${setup_src}" || die "failed to create default Setup.hs"
}

haskell-cabal-run_verbose() {
	echo "$@"
	"$@" || die "failed: $@"
}

cabal-hscolour() {
	haskell-cabal-run_verbose ./setup hscolour "$@"
}

cabal-haddock() {
	haskell-cabal-run_verbose ./setup haddock "$@"
}

cabal-die-if-nonempty() {
	local breakage_type=$1
	shift

	[[ "${#@}" == 0 ]] && return 0
	eerror "Detected ${breakage_type} packages: ${@}"
	die "//==-- Please, run 'haskell-updater' to fix ${breakage_type} packages --==//"
}

cabal-show-brokens() {
	[[ ${CABAL_REPORT_OTHER_BROKEN_PACKAGES} != yes ]] && return 0

	elog "ghc-pkg check: 'checking for other broken packages:'"
	# pretty-printer
	$(ghc-getghcpkg) check 2>&1 \
		| grep -E -v '^Warning: haddock-(html|interfaces): ' \
		| grep -E -v '^Warning: include-dirs: ' \
		| head -n 20

	cabal-die-if-nonempty 'broken' \
		$($(ghc-getghcpkg) check --simple-output)
}

cabal-show-old() {
	[[ ${CABAL_REPORT_OTHER_BROKEN_PACKAGES} != yes ]] && return 0

	cabal-die-if-nonempty 'outdated' \
		$("${EPREFIX}"/usr/sbin/haskell-updater --quiet --upgrade --list-only)
}

cabal-show-brokens-and-die() {
	cabal-show-brokens
	cabal-show-old

	die "$@"
}

cabal-configure() {
	local cabalconf=()

	if [[ -n "${CABAL_USE_HADDOCK}" ]] && use doc; then
		# We use the bundled with GHC version if exists
		# Haddock is very picky about index files
		# it generates for ghc's base and other packages.
		local p=${EPREFIX}/usr/bin/haddock-ghc-$(ghc-version)
		if [[ -f $p ]]; then
			cabalconf+=( --with-haddock="${p}" )
		else
			cabalconf+=( --with-haddock="${EPREFIX}"/usr/bin/haddock )
		fi
	fi
	if [[ -n "${CABAL_USE_PROFILE}" ]] && use profile; then
		cabalconf+=(--enable-library-profiling)
	fi

	if [[ -n "${CABAL_TEST_SUITE}" ]]; then
		cabalconf+=($(use_enable test tests))
	fi

	if [[ -n "${CABAL_GHC_CONSTRAINT}" ]]; then
		cabalconf+=($(cabal-constraint "ghc"))
	fi

	cabalconf+=(--ghc-options="$(ghc-make-args)")

	local option
	for option in ${HCFLAGS}
	do
		cabalconf+=(--ghc-option="$option")
	done

	# toolchain
	cabalconf+=(--with-ar="$(tc-getAR)")

	# Building GHCi libs on ppc64 causes "TOC overflow".
	if use ppc64; then
		cabalconf+=(--disable-library-for-ghci)
	fi

	# currently cabal does not respect CFLAGS and LDFLAGS on it's own (bug #333217)
	# so translate LDFLAGS to ghc parameters (with mild filtering).
	local flag
	for flag in   $CFLAGS; do
		case "${flag}" in
			-flto|-flto=*)
				# binutils does not support partial linking yet:
				# https://github.com/gentoo-haskell/gentoo-haskell/issues/1110
				# https://sourceware.org/PR12291
				einfo "Filter '${flag}' out of CFLAGS (avoid lto partial linking)"
				continue
				;;
		esac

		cabalconf+=(--ghc-option="-optc$flag")
	done
	for flag in  $LDFLAGS; do
		case "${flag}" in
			-flto|-flto=*)
				# binutils does not support partial linking yet:
				# https://github.com/gentoo-haskell/gentoo-haskell/issues/1110
				# https://sourceware.org/PR12291
				einfo "Filter '${flag}' out of LDFLAGS (avoid lto partial linking)"
				continue
				;;
		esac

		cabalconf+=(--ghc-option="-optl$flag")
	done

	# disable executable stripping for the executables, as portage will
	# strip by itself, and pre-stripping gives a QA warning.
	# cabal versions previous to 1.4 does not strip executables, and does
	# not accept the flag.
	# this fixes numerous bugs, amongst them;
	# bug #251881, bug #251882, bug #251884, bug #251886, bug #299494
	cabalconf+=(--disable-executable-stripping)

	cabalconf+=(--docdir="${EPREFIX}"/usr/share/doc/${PF})
	# As of Cabal 1.2, configure is quite quiet. For diagnostic purposes
	# it's better if the configure chatter is in the build logs:
	cabalconf+=(--verbose)

	# We build shared version of our Cabal where ghc ships it's shared
	# version of it. We will link ./setup as dynamic binary againt Cabal later.
	[[ ${CATEGORY}/${PN} == "dev-haskell/cabal" ]] && \
		$(ghc-supports-shared-libraries) && \
			cabalconf+=(--enable-shared)

	if $(ghc-supports-shared-libraries); then
		# Experimental support for dynamically linked binaries.
		# We are enabling it since 7.10.1_rc3
		if ver_test "$(ghc-version)" -ge "7.10.0.20150316"; then
			# we didn't enable it before as it was not stable on all arches
			cabalconf+=(--enable-shared)
			# Known to break on ghc-7.8/Cabal-1.18
			# https://ghc.haskell.org/trac/ghc/ticket/9625
			cabalconf+=(--enable-executable-dynamic)
		fi
	fi

	# --sysconfdir appeared in Cabal-1.18+
	if ./setup configure --help | grep -q -- --sysconfdir; then
		cabalconf+=(--sysconfdir="${EPREFIX}"/etc)
	fi

	# appeared in Cabal-1.18+ (see '--disable-executable-stripping')
	if ./setup configure --help | grep -q -- --disable-library-stripping; then
		cabalconf+=(--disable-library-stripping)
	fi

	set -- configure \
		--ghc --prefix="${EPREFIX}"/usr \
		--with-compiler="$(ghc-getghc)" \
		--with-hc-pkg="$(ghc-getghcpkg)" \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--libsubdir=${P}/ghc-$(ghc-version) \
		--datadir="${EPREFIX}"/usr/share/ \
		--datasubdir=${P}/ghc-$(ghc-version) \
		"${cabalconf[@]}" \
		${CABAL_CONFIGURE_FLAGS} \
		"$@" \
		${CABAL_EXTRA_CONFIGURE_FLAGS}
	echo ./setup "$@"
	./setup "$@" || cabal-show-brokens-and-die "setup configure failed"
}

cabal-build() {
	set --  build "$@" ${CABAL_EXTRA_BUILD_FLAGS}
	echo ./setup "$@"
	./setup "$@" \
		|| die "setup build failed"
}

cabal-copy() {
	set -- copy "$@" --destdir="${D}"
	echo ./setup "$@"
	./setup "$@" || die "setup copy failed"

	# cabal is a bit eager about creating dirs,
	# so remove them if they are empty
	rmdir "${ED}/usr/bin" 2> /dev/null
}

cabal-pkg() {
	# This does not actually register since we're using true instead
	# of ghc-pkg. So it just leaves the .conf file and we can
	# register that ourselves (if it exists).

	if [[ -n ${CABAL_HAS_LIBRARIES} ]]; then
		# Newer cabal can generate a package conf for us:
		./setup register --gen-pkg-config="${T}/${P}.conf"
		if [[ -d "${T}/${P}.conf" ]]; then
			ghc-install-pkg "${T}/${P}.conf"/*
		else
			ghc-install-pkg "${T}/${P}.conf"
		fi
	fi
}

# Some cabal libs are bundled along with some versions of ghc
# eg filepath-1.0 comes with ghc-6.6.1
# by putting CABAL_CORE_LIB_GHC_PV="6.6.1" in an ebuild we are declaring that
# when building with this version of ghc, the ebuild is a dummy that is it will
# install no files since the package is already included with ghc.
# However portage still records the dependency and we can upgrade the package
# to a later one that's not included with ghc.
# You can also put a space separated list, eg CABAL_CORE_LIB_GHC_PV="6.6 6.6.1".
# Those versions are taken as-is from ghc `--numeric-version`.
# Package manager versions are also supported:
#     CABAL_CORE_LIB_GHC_PV="7.10.* PM:7.8.4-r1".
cabal-is-dummy-lib() {
	local bin_ghc_version=$(ghc-version)
	local pm_ghc_version=$(ghc-pm-version)

	for version in ${CABAL_CORE_LIB_GHC_PV}; do
		[[ "${bin_ghc_version}" == ${version} ]] && return 0
		[[ "${pm_ghc_version}"  == ${version} ]] && return 0
	done

	return 1
}

# exported function: check if cabal is correctly installed for
# the currently active ghc (we cannot guarantee this with portage)
haskell-cabal_pkg_setup() {
	if [[ -n ${CABAL_HAS_LIBRARIES} ]]; then
		[[ ${RDEPEND} == *dev-lang/ghc* ]] || eqawarn "QA Notice: A library does not have runtime dependency on dev-lang/ghc."
	fi
	if [[ -n "${CABAL_UNKNOWN}" ]]; then
		eqawarn "QA Notice: Unknown entry in CABAL_FEATURES: ${CABAL_UNKNOWN}"
	fi
	if cabal-is-dummy-lib; then
		einfo "${P} is included in ghc-${CABAL_CORE_LIB_GHC_PV}, nothing to install."
	fi
}

haskell-cabal_src_prepare() {
	# Needed for packages that are still using MY_PN
	if [[ -n ${MY_PN} ]]; then
		local cabal_file="${S}/${MY_PN}.cabal"
	else
		local cabal_file="${CABAL_FILE}"
	fi

	if [[ -n ${CABAL_DISTFILE} ]]; then
		# pull revised cabal from upstream
		einfo "Using revised .cabal file from Hackage: revision ${CABAL_HACKAGE_REVISION}"
		cp "${DISTDIR}/${CABAL_DISTFILE}" "${cabal_file}" || die
	fi

	# Convert to unix line endings
	dos2unix "${cabal_file}" || die

	# Apply patches *after* pulling the revised cabal
	default

	[[ -n "${CABAL_CHDEPS}" ]] && cabal_chdeps "${CABAL_CHDEPS[@]}"
}

haskell-cabal_src_configure() {
	cabal-is-dummy-lib && return

	pushd "${S}" > /dev/null || die

	cabal-bootstrap

	cabal-configure "$@"

	popd > /dev/null || die
}

# exported function: nice alias
cabal_src_configure() {
	haskell-cabal_src_configure "$@"
}

# exported function: cabal-style bootstrap configure and compile
cabal_src_compile() {
	cabal-is-dummy-lib && return

	cabal-build

	if [[ -n "$CABAL_USE_HADDOCK" ]] && use doc; then
		if [[ -n "$CABAL_USE_HSCOLOUR" ]] && use hscolour; then
			# --hyperlink-source implies calling 'setup hscolour'
			haddock_args+=(--hyperlink-source)
		fi

		cabal-haddock "${haddock_args[@]}" $CABAL_EXTRA_HADDOCK_FLAGS

		if [[ -n "$CABAL_USE_HOOGLE" ]] && use hoogle; then
			cabal-haddock --hoogle $CABAL_EXTRA_HOOGLE_FLAGS
		fi
		if [[ -n "${CABAL_REBUILD_AFTER_DOC_WORKAROUND}" ]]; then
			ewarn "rebuild-after-doc-workaround is enabled. This is a"
			ewarn "temporary worakround to deal with https://github.com/haskell/cabal/issues/7213"
			ewarn "until the upstream issue can be resolved."
			cabal-build
		fi
	else
		if [[ -n "$CABAL_USE_HSCOLOUR" ]] && use hscolour; then
			cabal-hscolour $CABAL_EXTRA_HSCOLOUR_FLAGS
		fi

		if [[ -n "$CABAL_USE_HOOGLE" ]] && use hoogle; then
			ewarn "hoogle USE flag requires doc USE flag, building without hoogle"
		fi
	fi
}

haskell-cabal_src_compile() {
	pushd "${S}" > /dev/null || die

	cabal_src_compile "$@"

	popd > /dev/null || die
}

haskell-cabal_src_test() {
	local cabaltest=()

	pushd "${S}" > /dev/null || die

	if cabal-is-dummy-lib; then
		einfo ">>> No tests for dummy library: ${CATEGORY}/${PF}"
	else
		einfo ">>> Test phase [cabal test]: ${CATEGORY}/${PF}"

		# '--show-details=streaming' appeared in Cabal-1.20
		if ./setup test --help | grep -q -- "'streaming'"; then
			cabaltest+=(--show-details=streaming)
		fi

		set -- test \
			"${cabaltest[@]}" \
			${CABAL_TEST_FLAGS} \
			"$@" \
			${CABAL_EXTRA_TEST_FLAGS}
		echo ./setup "$@"
		./setup "$@" || die "cabal test failed"
	fi

	popd > /dev/null || die
}

# exported function: cabal-style copy and register
cabal_src_install() {
	if ! cabal-is-dummy-lib; then
		# Pass arguments to cabal-copy
		cabal-copy "$@"
		cabal-pkg
	fi

	# create a dummy local package conf file for haskell-updater
	# if it does not exist (dummy libraries and binaries w/o libraries)
	local ghc_confdir_with_prefix="$(ghc-confdir)"
	# remove EPREFIX
	dodir "${ghc_confdir_with_prefix#${EPREFIX}}"
	local hint_db="${D}/$(ghc-confdir)"
	local hint_file="${hint_db}/gentoo-empty-${CATEGORY}-${PF}.conf"
	mkdir -p "${hint_db}" || die
	touch "${hint_file}" || die
}

# Arguments passed to this function will make their way to `cabal-copy`
# and eventually `./setup copy`. This allows you to specify which
# components will be installed.
# e.g. `haskell-cabal_src_install "lib:${PN}"` will only install the library
haskell-cabal_src_install() {
	pushd "${S}" > /dev/null || die

	cabal_src_install "$@"

	popd > /dev/null || die
}

haskell-cabal_pkg_postinst() {
	ghc-package_pkg_postinst
}

haskell-cabal_pkg_postrm() {
	ghc-package_pkg_postrm
}

# @FUNCTION: cabal_flag
# @DESCRIPTION:
# ebuild.sh:use_enable() taken as base
#
# Usage examples:
#
#     CABAL_CONFIGURE_FLAGS=$(cabal_flag gui)
#  leads to "--flags=gui" or "--flags=-gui" (useflag 'gui')
#
#     CABAL_CONFIGURE_FLAGS=$(cabal_flag gtk gui)
#  also leads to "--flags=gui" or " --flags=-gui" (useflag 'gtk')
#
cabal_flag() {
	if [[ -z "$1" ]]; then
		echo "!!! cabal_flag() called without a parameter." >&2
		echo "!!! cabal_flag() <USEFLAG> [<cabal_flagname>]" >&2
		return 1
	fi

	local UWORD=${2:-$1}

	if use "$1"; then
		echo "--flags=${UWORD}"
	else
		echo "--flags=-${UWORD}"
	fi

	return 0
}

# @FUNCTION: cabal_chdeps
# @DESCRIPTION:
# Allows easier patching of $CABAL_FILE (${S}/${PN}.cabal by default)
# depends
#
# Accepts argument list as pairs of substitutions: <from-string> <to-string>...
#
# Dies on error.
#
# Usage examples:
#
# src_prepare() {
#    cabal_chdeps \
#        'base >= 4.2 && < 4.6' 'base >= 4.2 && < 4.7' \
#        'containers ==0.4.*' 'containers >= 0.4 && < 0.6'
#}
# or
# src_prepare() {
#    CABAL_FILE=${S}/${CABAL_PN}.cabal cabal_chdeps \
#        'base >= 4.2 && < 4.6' 'base >= 4.2 && < 4.7'
#    CABAL_FILE=${S}/${CABAL_PN}-tools.cabal cabal_chdeps \
#        'base == 3.*' 'base >= 4.2 && < 4.7'
#}
#
cabal_chdeps() {
	# Needed for compatibility with ebuilds still using MY_PN
	if [[ -n ${MY_PN} ]]; then
		local cabal_file="${S}/${MY_PN}.cabal"
	else
		local cabal_file="${CABAL_FILE}"
	fi

	local from_ss # ss - substring
	local to_ss
	local orig_c # c - contents
	local new_c

	[[ -f "${cabal_file}" ]] || die "cabal file '${cabal_file}' does not exist"

	orig_c=$(< "${cabal_file}")

	while :; do
		from_pat=$1
		to_str=$2

		[[ -n ${from_pat} ]] || break
		[[ -n ${to_str} ]] || die "'${from_str}' does not have 'to' part"

		einfo "CHDEP: '${from_pat}' -> '${to_str}'"

		# escape pattern-like symbols
		from_pat=${from_pat//\*/\\*}
		from_pat=${from_pat//\[/\\[}

		new_c=${orig_c//${from_pat}/${to_str}}

		if [[ -n $CABAL_DEBUG_LOOSENING ]]; then
			echo "${orig_c}" >"${T}/${cabal_file}".pre
			echo "${new_c}" >"${T}/${cabal_file}".post
			diff -u "${T}/${cabal_file}".{pre,post}
		fi

		[[ "${orig_c}" == "${new_c}" ]] && die "no trigger for '${from_pat}'"
		orig_c=${new_c}
		shift
		shift
	done

	echo "${new_c}" > "$cabal_file" ||
		die "failed to update"
}

# @FUNCTION: cabal-constraint
# @DESCRIPTION:
# Allowes to set contraint to the libraries that are
# used by specified package
cabal-constraint() {
	while read p v ; do
		echo "--constraint \"$p == $v\""
	done < $(ghc-pkgdeps ${1})
}

# @FUNCTION: replace-hcflags
# @USAGE: <old> <new>
# @DESCRIPTION:
# Replace the <old> flag with <new> in HCFLAGS. Accepts shell globs for <old>.
# The implementation is picked from flag-o-matic.eclass:replace-flags()
replace-hcflags() {
	[[ $# != 2 ]] && die "Usage: replace-hcflags <old flag> <new flag>"

	local f new=()
	for f in ${HCFLAGS} ; do
		# Note this should work with globs like -O*
		if [[ ${f} == ${1} ]]; then
			einfo "HCFLAGS: replacing '${f}' to '${2}'"
			f=${2}
		fi
		new+=( "${f}" )
	done
	export HCFLAGS="${new[*]}"

	return 0
}

fi

EXPORT_FUNCTIONS pkg_setup src_prepare src_configure src_compile src_test src_install pkg_postinst pkg_postrm

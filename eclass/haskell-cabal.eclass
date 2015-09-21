# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: haskell-cabal.eclass
# @MAINTAINER:
# Haskell herd <haskell@gentoo.org>
# @AUTHOR:
# Original author: Andres Loeh <kosmikus@gentoo.org>
# Original author: Duncan Coutts <dcoutts@gentoo.org>
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
#   alex       --  lexer/scanner generator
#   happy      --  parser generator
#   c2hs       --  C interface generator
#   cpphs      --  C preprocessor clone written in Haskell
#   profile    --  if package supports to build profiling-enabled libraries
#   bootstrap  --  only used for the cabal package itself
#   bin        --  the package installs binaries
#   lib        --  the package installs libraries
#   nocabaldep --  don't add dependency on cabal.
#                  only used for packages that _must_ not pull the dependency
#                  on cabal, but still use this eclass (e.g. haskell-updater).
#   ghcdeps    --  constraint dependency on package to ghc onces
#                  only used for packages that use libghc internally and _must_
#                  not pull upper versions
#   test-suite --  add support for cabal test-suites (introduced in Cabal-1.8)

inherit eutils ghc-package multilib multiprocessing

# @ECLASS-VARIABLE: CABAL_EXTRA_CONFIGURE_FLAGS
# @DESCRIPTION:
# User-specified additional parameters passed to 'setup configure'.
# example: /etc/portage/make.conf:
#    CABAL_EXTRA_CONFIGURE_FLAGS="--enable-shared --enable-executable-dynamic"
: ${CABAL_EXTRA_CONFIGURE_FLAGS:=}

# @ECLASS-VARIABLE: CABAL_EXTRA_BUILD_FLAGS
# @DESCRIPTION:
# User-specified additional parameters passed to 'setup build'.
# example: /etc/portage/make.conf: CABAL_EXTRA_BUILD_FLAGS=-v
: ${CABAL_EXTRA_BUILD_FLAGS:=}

# @ECLASS-VARIABLE: GHC_BOOTSTRAP_FLAGS
# @DESCRIPTION:
# User-specified additional parameters for ghc when building
# _only_ 'setup' binary bootstrap.
# example: /etc/portage/make.conf: GHC_BOOTSTRAP_FLAGS=-dynamic to make
# linking 'setup' faster.
: ${GHC_BOOTSTRAP_FLAGS:=}

# @ECLASS-VARIABLE: CABAL_DEBUG_LOOSENING
# @DESCRIPTION:
# Show debug output for 'cabal_chdeps' function if set.
# Needs working 'diff'.
: ${CABAL_DEBUG_LOOSENING:=}

HASKELL_CABAL_EXPF="pkg_setup src_compile src_test src_install pkg_postinst pkg_postrm"

# 'dev-haskell/cabal' passes those options with ./configure-based
# configuration, but most packages don't need/don't accept it:
# #515362, #515362
QA_CONFIGURE_OPTIONS+=" --with-compiler --with-hc --with-hc-pkg --with-gcc"

case "${EAPI:-0}" in
	2|3|4|5) HASKELL_CABAL_EXPF+=" src_configure" ;;
	*) ;;
esac

EXPORT_FUNCTIONS ${HASKELL_CABAL_EXPF}

for feature in ${CABAL_FEATURES}; do
	case ${feature} in
		haddock)    CABAL_USE_HADDOCK=yes;;
		hscolour)   CABAL_USE_HSCOLOUR=yes;;
		hoogle)     CABAL_USE_HOOGLE=yes;;
		alex)       CABAL_USE_ALEX=yes;;
		happy)      CABAL_USE_HAPPY=yes;;
		c2hs)       CABAL_USE_C2HS=yes;;
		cpphs)      CABAL_USE_CPPHS=yes;;
		profile)    CABAL_USE_PROFILE=yes;;
		bootstrap)  CABAL_BOOTSTRAP=yes;;
		bin)        CABAL_HAS_BINARIES=yes;;
		lib)        CABAL_HAS_LIBRARIES=yes;;
		nocabaldep) CABAL_FROM_GHC=yes;;
		ghcdeps)    CABAL_GHC_CONSTRAINT=yes;;
		test-suite) CABAL_TEST_SUITE=yes;;
		*) CABAL_UNKNOWN="${CABAL_UNKNOWN} ${feature}";;
	esac
done

if [[ -n "${CABAL_USE_HADDOCK}" ]]; then
	IUSE="${IUSE} doc"
	# don't require depend on itself to build docs.
	# ebuild bootstraps docs from just built binary
	#
	# starting from ghc-7.10.2 we install haddock bundled with
	# ghc to keep links to base and ghc library, otherwise
	# newer haddock versions change index format and can't
	# read index files for packages coming with ghc.
	[[ ${CATEGORY}/${PN} = "dev-haskell/haddock" ]] || \
		DEPEND="${DEPEND} doc? ( || ( dev-haskell/haddock >=dev-lang/ghc-7.10.2 ) )"
fi

if [[ -n "${CABAL_USE_HSCOLOUR}" ]]; then
	IUSE="${IUSE} hscolour"
	DEPEND="${DEPEND} hscolour? ( dev-haskell/hscolour )"
fi

if [[ -n "${CABAL_USE_HOOGLE}" ]]; then
	# enabled only in ::haskell
	CABAL_USE_HOOGLE=
fi

if [[ -n "${CABAL_USE_ALEX}" ]]; then
	DEPEND="${DEPEND} dev-haskell/alex"
fi

if [[ -n "${CABAL_USE_HAPPY}" ]]; then
	DEPEND="${DEPEND} dev-haskell/happy"
fi

if [[ -n "${CABAL_USE_C2HS}" ]]; then
	DEPEND="${DEPEND} dev-haskell/c2hs"
fi

if [[ -n "${CABAL_USE_CPPHS}" ]]; then
	DEPEND="${DEPEND} dev-haskell/cpphs"
fi

if [[ -n "${CABAL_USE_PROFILE}" ]]; then
	IUSE="${IUSE} profile"
fi

if [[ -n "${CABAL_TEST_SUITE}" ]]; then
	IUSE="${IUSE} test"
fi

# We always use a standalone version of Cabal, rather than the one that comes
# with GHC. But of course we can't depend on cabal when building cabal itself.
if [[ -z ${CABAL_MIN_VERSION} ]]; then
	CABAL_MIN_VERSION=1.1.4
fi
if [[ -z "${CABAL_BOOTSTRAP}" && -z "${CABAL_FROM_GHC}" ]]; then
	DEPEND="${DEPEND} >=dev-haskell/cabal-${CABAL_MIN_VERSION}"
fi

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
			_CABAL_VERSION_CACHE="$(ghc-extractportageversion dev-haskell/cabal)"
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
		die "No Setup.lhs or Setup.hs found"
	fi

	if [[ -z "${CABAL_BOOTSTRAP}" && -z "${CABAL_FROM_GHC}" ]] && ! ghc-sanecabal "${CABAL_MIN_VERSION}"; then
		eerror "The package dev-haskell/cabal is not correctly installed for"
		eerror "the currently active version of ghc ($(ghc-version)). Please"
		eerror "run haskell-updater or re-build dev-haskell/cabal."
		die "cabal is not correctly installed"
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

	make_setup() {
		set -- -package "${cabalpackage}" --make "${setupmodule}" \
			"${setup_bootstrap_args[@]}" \
			${HCFLAGS} \
			${GHC_BOOTSTRAP_FLAGS} \
			"$@" \
			-o setup
		echo $(ghc-getghc) "$@"
		$(ghc-getghc) "$@"
	}
	if $(ghc-supports-shared-libraries); then
		# # some custom build systems might use external libraries,
		# # for which we don't have shared libs, so keep static fallback
		# bug #411789, http://hackage.haskell.org/trac/ghc/ticket/5743#comment:3
		# http://hackage.haskell.org/trac/ghc/ticket/7062
		# http://hackage.haskell.org/trac/ghc/ticket/3072
		# ghc does not set RPATH for extralibs, thus we do it ourselves by hands
		einfo "Prepending $(ghc-libdir) to LD_LIBRARY_PATH"
		if [[ ${CHOST} != *-darwin* ]]; then
			LD_LIBRARY_PATH="$(ghc-libdir)${LD_LIBRARY_PATH:+:}${LD_LIBRARY_PATH}"
			export LD_LIBRARY_PATH
		else
			DYLD_LIBRARY_PATH="$(ghc-libdir)${DYLD_LIBRARY_PATH:+:}${DYLD_LIBRARY_PATH}"
			export DYLD_LIBRARY_PATH
		fi
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

cabal-hscolour() {
	set -- hscolour "$@"
	echo ./setup "$@"
	./setup "$@" || die "setup hscolour failed"
}

cabal-haddock() {
	set -- haddock "$@"
	echo ./setup "$@"
	./setup "$@" || die "setup haddock failed"
}

cabal-hoogle() {
	ewarn "hoogle USE flag requires doc USE flag, building without hoogle"
}

cabal-hscolour-haddock() {
	# --hyperlink-source implies calling 'setup hscolour'
	set -- haddock --hyperlink-source
	echo ./setup "$@"
	./setup "$@" --hyperlink-source || die "setup haddock --hyperlink-source failed"
}

cabal-hoogle-haddock() {
	set -- haddock --hoogle
	echo ./setup "$@"
	./setup "$@" || die "setup haddock --hoogle failed"
}

cabal-hoogle-hscolour-haddock() {
	cabal-hscolour-haddock
	cabal-hoogle-haddock
}

cabal-hoogle-hscolour() {
	ewarn "hoogle USE flag requires doc USE flag, building without hoogle"
	cabal-hscolour
}

cabal-die-if-nonempty() {
	local breakage_type=$1
	shift

	[[ "${#@}" == 0 ]] && return 0
	eerror "Detected ${breakage_type} packages: ${@}"
	die "//==-- Please, run 'haskell-updater' to fix ${breakage_type} packages --==//"
}

cabal-show-brokens() {
	elog "ghc-pkg check: 'checking for other broken packages:'"
	# pretty-printer
	$(ghc-getghcpkg) check 2>&1 \
		| egrep -v '^Warning: haddock-(html|interfaces): ' \
		| egrep -v '^Warning: include-dirs: ' \
		| head -n 20

	cabal-die-if-nonempty 'broken' \
		$($(ghc-getghcpkg) check --simple-output)
}

cabal-show-old() {
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
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=

	if [[ -n "${CABAL_USE_HADDOCK}" ]] && use doc; then
		# We use the bundled with GHC version if exists
		# Haddock is very picky about index files
		# it generates for ghc's base and other packages.
		local p=${EPREFIX}/usr/bin/haddock-ghc-$(ghc-version)
		if [[ -f $p ]]; then
			cabalconf+=(--with-haddock="${p}")
		else
			cabalconf+=(--with-haddock=${EPREFIX}/usr/bin/haddock)
		fi
	fi
	if [[ -n "${CABAL_USE_PROFILE}" ]] && use profile; then
		cabalconf+=(--enable-library-profiling)
	fi
	if [[ -n "${CABAL_USE_ALEX}" ]]; then
		cabalconf+=(--with-alex=${EPREFIX}/usr/bin/alex)
	fi

	if [[ -n "${CABAL_USE_HAPPY}" ]]; then
		cabalconf+=(--with-happy=${EPREFIX}/usr/bin/happy)
	fi

	if [[ -n "${CABAL_USE_C2HS}" ]]; then
		cabalconf+=(--with-c2hs=${EPREFIX}/usr/bin/c2hs)
	fi
	if [[ -n "${CABAL_USE_CPPHS}" ]]; then
		cabalconf+=(--with-cpphs=${EPREFIX}/usr/bin/cpphs)
	fi
	if [[ -n "${CABAL_TEST_SUITE}" ]]; then
		cabalconf+=($(use_enable test tests))
	fi

	if [[ -n "${CABAL_GHC_CONSTRAINT}" ]]; then
		cabalconf+=($(cabal-constraint "ghc"))
	fi

	local option
	for option in ${HCFLAGS}
	do
		cabalconf+=(--ghc-option="$option")
	done

	# parallel on all available cores
	if ghc-supports-parallel-make; then
		local max_jobs=$(makeopts_jobs)

		# limit to very small value, as parallelism
		# helps slightly, but makes things severely worse
		# when amount of threads is Very Large.
		[[ ${max_jobs} -gt 4 ]] && max_jobs=4

		cabalconf+=(--ghc-option=-j"$max_jobs")
	fi

	# Building GHCi libs on ppc64 causes "TOC overflow".
	if use ppc64; then
		cabalconf+=(--disable-library-for-ghci)
	fi

	# currently cabal does not respect CFLAGS and LDFLAGS on it's own (bug #333217)
	# so translate LDFLAGS to ghc parameters (without filtering)
	local flag
	for flag in   $CFLAGS; do cabalconf+=(--ghc-option="-optc$flag"); done
	for flag in  $LDFLAGS; do cabalconf+=(--ghc-option="-optl$flag"); done

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
		if version_is_at_least "7.10.0.20150316" "$(ghc-version)"; then
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
		${CABAL_EXTRA_CONFIGURE_FLAGS} \
		"$@"
	echo ./setup "$@"
	./setup "$@" || cabal-show-brokens-and-die "setup configure failed"
}

cabal-build() {
	set --  build ${CABAL_EXTRA_BUILD_FLAGS} "$@"
	echo ./setup "$@"
	./setup "$@" \
		|| die "setup build failed"
}

cabal-copy() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && ED=${D}

	set -- copy --destdir="${D}" "$@"
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
		ghc-install-pkg "${T}/${P}.conf"
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
	if [[ -z "${CABAL_HAS_BINARIES}" ]] && [[ -z "${CABAL_HAS_LIBRARIES}" ]]; then
		eqawarn "QA Notice: Neither bin nor lib are in CABAL_FEATURES."
	fi
	if [[ -n "${CABAL_UNKNOWN}" ]]; then
		eqawarn "QA Notice: Unknown entry in CABAL_FEATURES: ${CABAL_UNKNOWN}"
	fi
	if cabal-is-dummy-lib; then
		einfo "${P} is included in ghc-${CABAL_CORE_LIB_GHC_PV}, nothing to install."
	fi
}

haskell-cabal_src_configure() {
	cabal-is-dummy-lib && return

	pushd "${S}" > /dev/null

	cabal-bootstrap

	cabal-configure "$@"

	popd > /dev/null
}

# exported function: nice alias
cabal_src_configure() {
	haskell-cabal_src_configure "$@"
}

# exported function: cabal-style bootstrap configure and compile
cabal_src_compile() {
	# it's a common mistake when one bumps ebuild to EAPI="2" (and upper)
	# and forgets to separate src_compile() to src_configure()/src_compile().
	# Such error leads to default src_configure and we lose all passed flags.
	if ! has "${EAPI:-0}" 0 1; then
		local passed_flag
		for passed_flag in "$@"; do
			[[ ${passed_flag} == --flags=* ]] && \
				eqawarn "QA Notice: Cabal option '${passed_flag}' has effect only in src_configure()"
		done
	fi

	cabal-is-dummy-lib && return

	has src_configure ${HASKELL_CABAL_EXPF} || haskell-cabal_src_configure "$@"
	cabal-build

	if [[ -n "${CABAL_USE_HADDOCK}" ]] && use doc; then
		if [[ -n "${CABAL_USE_HSCOLOUR}" ]] && use hscolour; then
			if [[ -n "${CABAL_USE_HOOGLE}" ]] && use hoogle; then
				# hoogle, hscolour and haddock
				cabal-hoogle-hscolour-haddock
			else
				# haddock and hscolour
				cabal-hscolour-haddock
			fi
		else
			if [[ -n "${CABAL_USE_HOOGLE}" ]] && use hoogle; then
				# hoogle and haddock
				cabal-hoogle-haddock
			else
				# just haddock
				cabal-haddock
			fi
		fi
	else
		if [[ -n "${CABAL_USE_HSCOLOUR}" ]] && use hscolour; then
			if [[ -n "${CABAL_USE_HOOGLE}" ]] && use hoogle; then
				# hoogle and hscolour
				cabal-hoogle-hscolour
			else
				# just hscolour
				cabal-hscolour
			fi
		else
			if [[ -n "${CABAL_USE_HOOGLE}" ]] && use hoogle; then
				# just hoogle
				cabal-hoogle
			fi
		fi
	fi
}

haskell-cabal_src_compile() {
	pushd "${S}" > /dev/null

	cabal_src_compile "$@"

	popd > /dev/null
}

haskell-cabal_src_test() {
	pushd "${S}" > /dev/null

	if cabal-is-dummy-lib; then
		einfo ">>> No tests for dummy library: ${CATEGORY}/${PF}"
	else
		einfo ">>> Test phase [cabal test]: ${CATEGORY}/${PF}"
		set -- test "$@"
		echo ./setup "$@"
		./setup "$@" || die "cabal test failed"
	fi

	popd > /dev/null
}

# exported function: cabal-style copy and register
cabal_src_install() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=

	if ! cabal-is-dummy-lib; then
		cabal-copy
		cabal-pkg
	fi

	# create a dummy local package conf file for haskell-updater
	# if it does not exist (dummy libraries and binaries w/o libraries)
	local ghc_confdir_with_prefix="$(ghc-confdir)"
	# remove EPREFIX
	dodir ${ghc_confdir_with_prefix#${EPREFIX}}
	local hint_db="${D}/$(ghc-confdir)"
	local hint_file="${hint_db}/${PF}.conf"
	mkdir -p "${hint_db}" || die
	touch "${hint_file}" || die
}

haskell-cabal_src_install() {
	pushd "${S}" > /dev/null

	cabal_src_install

	popd > /dev/null
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
#    CABAL_FILE=${S}/${MY_PN}.cabal cabal_chdeps \
#        'base >= 4.2 && < 4.6' 'base >= 4.2 && < 4.7'
#    CABAL_FILE=${S}/${MY_PN}-tools.cabal cabal_chdeps \
#        'base == 3.*' 'base >= 4.2 && < 4.7'
#}
#
cabal_chdeps() {
	local cabal_fn=${MY_PN:-${PN}}.cabal
	local cf=${CABAL_FILE:-${S}/${cabal_fn}}
	local from_ss # ss - substring
	local to_ss
	local orig_c # c - contents
	local new_c

	[[ -f $cf ]] || die "cabal file '$cf' does not exist"

	orig_c=$(< "$cf")

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
			echo "${orig_c}" >"${T}/${cf}".pre
			echo "${new_c}" >"${T}/${cf}".post
			diff -u "${T}/${cf}".{pre,post}
		fi

		[[ "${orig_c}" == "${new_c}" ]] && die "no trigger for '${from_pat}'"
		orig_c=${new_c}
		shift
		shift
	done

	echo "${new_c}" > "$cf" ||
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

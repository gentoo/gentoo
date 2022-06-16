# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ghc-package.eclass
# @MAINTAINER:
# "Gentoo's Haskell Language team" <haskell@gentoo.org>
# @AUTHOR:
# Original Author: Andres Loeh <kosmikus@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: This eclass helps with the Glasgow Haskell Compiler's package configuration utility.
# @DESCRIPTION:
# Helper eclass to handle ``ghc`` installation/upgrade/deinstallation process.

inherit multiprocessing

# Maintain version-testing compatibility with ebuilds not using EAPI 7.
case ${EAPI} in
	7|8) ;;
	6) inherit eapi7-ver ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# GHC uses it's own native code generator. Portage's
# QA check generates false positive because it assumes
# presence of GCC-specific sections.
#
# Workaround false positiove by disabling the check completely.
# bug #722078, bug #677600
QA_FLAGS_IGNORED='.*'

# @FUNCTION: ghc-getghc
# @DESCRIPTION:
# returns the name of the ``ghc`` executable
ghc-getghc() {
	if ! type -P ${HC:-ghc}; then
		ewarn "ghc not found"
		type -P false
	fi
}

# @FUNCTION: ghc-getghcpkg
# @INTERNAL
# @DESCRIPTION:
# Internal function determines returns the name of the ghc-pkg executable
ghc-getghcpkg() {
	if ! type -P ${HC_PKG:-ghc-pkg}; then
		ewarn "ghc-pkg not found"
		type -P false
	fi
}

# @FUNCTION: ghc-getghcpkgbin
# @DESCRIPTION:
# returns the name of the ``ghc-pkg`` binary (``ghc-pkg``
# itself usually is a shell script, and we have to
# bypass the script under certain circumstances);
# for ``Cabal``, we add an empty global package config file,
# because for some reason the global package file
# must be specified
ghc-getghcpkgbin() {
	local empty_db="${T}/empty.conf.d" ghc_pkg="$(ghc-libdir)/bin/ghc-pkg"
	if [[ ! -d ${empty_db} ]]; then
		"${ghc_pkg}" init "${empty_db}" || die "Failed to initialize empty global db"
	fi
	echo "$(ghc-libdir)/bin/ghc-pkg" "--global-package-db=${empty_db}"
}

# @FUNCTION: ghc-version
# @DESCRIPTION:
# returns upstream version of ``ghc``
# as reported by ``--numeric-version``.
#
# Examples: ``7.10.2``, ``7.9.20141222``
_GHC_VERSION_CACHE=""
ghc-version() {
	if [[ -z "${_GHC_VERSION_CACHE}" ]]; then
		_GHC_VERSION_CACHE="$($(ghc-getghc) --numeric-version)"
	fi
	echo "${_GHC_VERSION_CACHE}"
}

# @FUNCTION: ghc-pm-version
# @DESCRIPTION:
# returns package manager(PM) version of ``ghc``
# as reported by ``$(best_version)``
#
# Examples: ``PM:7.10.2``, ``PM:7.10.2_rc1``, ``PM:7.8.4-r4``
_GHC_PM_VERSION_CACHE=""
ghc-pm-version() {
	local pm_ghc_p

	if [[ -z "${_GHC_PM_VERSION_CACHE}" ]]; then
		pm_ghc_p=$(best_version dev-lang/ghc)
		_GHC_PM_VERSION_CACHE="PM:${pm_ghc_p#dev-lang/ghc-}"
	fi
	echo "${_GHC_PM_VERSION_CACHE}"
}

# @FUNCTION: ghc-cabal-version
# @DESCRIPTION:
# return version of the ``Cabal`` library bundled with ``ghc``
ghc-cabal-version() {
	# outputs in format: 'version: 1.18.1.5'
	set -- `$(ghc-getghcpkg) --package-db=$(ghc-libdir)/package.conf.d.initial field Cabal version`
	echo "$2"
}

# @FUNCTION: ghc-is-dynamic
# @DESCRIPTION:
# checks if ``ghc`` is built against dynamic libraries
# binaries linked against ``GHC`` library (and using plugin loading)
# have to be linked the same way:
# https://ghc.haskell.org/trac/ghc/ticket/10301
ghc-is-dynamic() {
	$(ghc-getghc) --info | grep "GHC Dynamic" | grep -q "YES"
}

# @FUNCTION: ghc-supports-shared-libraries
# @DESCRIPTION:
# checks if ``ghc`` is built with support for building
# shared libraries (aka ``-dynamic`` option)
ghc-supports-shared-libraries() {
	$(ghc-getghc) --info | grep "RTS ways" | grep -q "dyn"
}

# @FUNCTION: ghc-supports-threaded-runtime
# @DESCRIPTION:
# checks if ``ghc`` is built with support for threaded
# runtime (aka ``-threaded`` option)
ghc-supports-threaded-runtime() {
	$(ghc-getghc) --info | grep "RTS ways" | grep -q "thr"
}

# @FUNCTION: ghc-supports-smp
# @DESCRIPTION:
# checks if ``ghc`` is built with support for multiple cores runtime
ghc-supports-smp() {
	$(ghc-getghc) --info | grep "Support SMP" | grep -q "YES"
}

# @FUNCTION: ghc-supports-interpreter
# @DESCRIPTION:
# checks if ``ghc`` has interpreter mode (aka ``GHCi``).
# It usually means that ``ghc`` supports for template haskell.
ghc-supports-interpreter() {
	$(ghc-getghc) --info | grep "Have interpreter" | grep -q "YES"
}

# @FUNCTION: ghc-supports-parallel-make
# @DESCRIPTION:
# checks if ``ghc`` has support for ``--make -j`` mode.
# The option was introduced in ``ghc-7.8-rc1``.
ghc-supports-parallel-make() {
	$(ghc-getghc) --info | grep "Support parallel --make" | grep -q "YES"
}

# @FUNCTION: ghc-extract-pm-version
# @DESCRIPTION:
# extract the version of a portage-installed package
ghc-extract-pm-version() {
	local pkg
	local version
	pkg="$(best_version $1)"
	version="${pkg#$1-}"
	version="${version%-r*}"
	version="${version%_pre*}"
	echo "${version}"
}

# @FUNCTION: ghc-libdir
# @DESCRIPTION:
# returns the library directory
_GHC_LIBDIR_CACHE=""
ghc-libdir() {
	if [[ -z "${_GHC_LIBDIR_CACHE}" ]]; then
		_GHC_LIBDIR_CACHE="$($(ghc-getghc) --print-libdir)"
	fi
	echo "${_GHC_LIBDIR_CACHE}"
}

# @FUNCTION: ghc-make-args
# @DESCRIPTION:
# Returns default arguments passed along ``ghc --make``
# build mode. Used mainly to enable parallel build mode.
ghc-make-args() {
	local ghc_make_args=()
	# parallel on all available cores
	if ghc-supports-smp && ghc-supports-parallel-make; then
		# It should have been just -j$(makeopts_jobs)
		# but GHC does not yet have nice defaults:
		#    https://ghc.haskell.org/trac/ghc/ticket/9221#comment:57
		# SMP is a requirement for parallel GC's gen0
		# 'qb' balancing.
		echo "-j$(makeopts_jobs) +RTS -A256M -qb0 -RTS"
		ghc_make_args=()
	fi
	echo "${ghc_make_args[@]}"
}

# @FUNCTION: ghc-confdir
# @DESCRIPTION:
# returns the (Gentoo) library configuration directory, we
# store here a hint for ``haskell-updater`` about packages
# installed for old ``ghc`` versions and current ones.
ghc-confdir() {
	echo "$(ghc-libdir)/gentoo"
}

# @FUNCTION: ghc-package-db
# @DESCRIPTION:
# returns the global package database directory
ghc-package-db() {
	echo "$(ghc-libdir)/package.conf.d"
}

# @FUNCTION: ghc-localpkgconfd
# @DESCRIPTION:
# returns the name of the local (package-specific)
# package configuration file
ghc-localpkgconfd() {
	echo "${PF}.conf.d"
}

# @FUNCTION: ghc-package-exists
# @DESCRIPTION:
# tests if a ``ghc`` package exists
ghc-package-exists() {
	$(ghc-getghcpkg) describe "$1" > /dev/null 2>&1
}

# @FUNCTION: check-for-collisions
# @DESCRIPTION:
# makes sure no packages
# have the same version as initial package setup
check-for-collisions() {
	local localpkgconf=$1
	local checked_pkg
	local initial_pkg_db="$(ghc-libdir)/package.conf.d.initial"

	for checked_pkg in `$(ghc-getghcpkgbin) -f "${localpkgconf}" list --simple-output`
	do
		# should return empty output
		local collided=`$(ghc-getghcpkgbin) -f ${initial_pkg_db} list --simple-output "${checked_pkg}"`

		if [[ -n ${collided} ]]; then
			eerror "Cabal package '${checked_pkg}' is shipped with '$(ghc-pm-version)' ('$(ghc-version)')."
			eerror "Ebuild author forgot an entry in CABAL_CORE_LIB_GHC_PV='${CABAL_CORE_LIB_GHC_PV}'."
			eerror "Found in ${initial_pkg_db}."
			die
		fi
	done
}

# @FUNCTION: ghc-install-pkg
# @DESCRIPTION:
# moves the local (package-specific) package configuration
# file to its final destination
ghc-install-pkg() {
	local localpkgconf="${T}/$(ghc-localpkgconfd)"
	local pkg_path pkg pkg_db="${D}/$(ghc-package-db)" hint_db="${D}/$(ghc-confdir)"

	$(ghc-getghcpkgbin) init "${localpkgconf}" || die "Failed to initialize empty local db"
	for pkg_config_file in "$@"; do
		$(ghc-getghcpkgbin) -f "${localpkgconf}" update - --force \
				< "${pkg_config_file}" || die "failed to register ${pkg}"
	done

	check-for-collisions "${localpkgconf}"

	mkdir -p "${pkg_db}" || die
	for pkg_path in "${localpkgconf}"/*.conf; do
		pkg=$(basename "${pkg_path}")
		cp "${pkg_path}" "${pkg_db}/${pkg}" || die
	done

	mkdir -p "${hint_db}" || die
	for pkg_config_file in "$@"; do
		local pkg_name="gentoo-${CATEGORY}-${PF}-"$(basename "${pkg_config_file}")
		cp "${pkg_config_file}" "${hint_db}/${pkg_name}" || die
		chmod 0644 "${hint_db}/${pkg_name}" || die
	done
}

# @FUNCTION: ghc-recache-db
# @DESCRIPTION:
# updates ``package.cache`` binary cacne for registered ``*.conf``
# packages
ghc-recache-db() {
	einfo "Recaching GHC package DB"
	$(ghc-getghcpkg) recache
}

# @FUNCTION: ghc-register-pkg
# @DESCRIPTION:
# registers all packages in the local (package-specific)
# package configuration file
ghc-register-pkg() {
	ghc-recache-db
}

# @FUNCTION: ghc-reregister
# @DESCRIPTION:
# re-adds all available ``.conf`` files to the global
# package conf file, to be used on a ``ghc`` reinstallation
ghc-reregister() {
	ghc-recache-db
}

# @FUNCTION: ghc-unregister-pkg
# @DESCRIPTION:
# unregisters a package configuration file
ghc-unregister-pkg() {
	ghc-recache-db
}

# @FUNCTION: ghc-pkgdeps
# @DESCRIPTION:
# exported function: loads a package dependency in a form
# ``cabal_package`` version
ghc-pkgdeps() {
	echo $($(ghc-getghcpkg) describe "${1}") \
	| sed \
			-e '/depends/,/^.*:/ !d' \
			-e 's/\(.*\)-\(.*\)-\(.*\)/\1 \2/' \
			-e 's/^.*://g'
}

# @FUNCTION: ghc-package_pkg_postinst
# @DESCRIPTION:
# updates ``package.cache`` after package install
ghc-package_pkg_postinst() {
	ghc-recache-db
}

# @FUNCTION: ghc-package_pkg_prerm
# @DESCRIPTION:
# updates ``package.cache`` after package deinstall
ghc-package_pkg_prerm() {
	ewarn "ghc-package.eclass: 'ghc-package_pkg_prerm()' is a noop"
	ewarn "ghc-package.eclass: consider 'haskell-cabal_pkg_postrm()' instead"
}

# @FUNCTION: ghc-package_pkg_postrm
# @DESCRIPTION:
# updates ``package.cache`` after package deinstall
ghc-package_pkg_postrm() {
	ghc-recache-db
}

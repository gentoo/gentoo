# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: perl-module.eclass
# @MAINTAINER:
# perl@gentoo.org
# @AUTHOR:
# Seemant Kulleen <seemant@gentoo.org>
# Andreas K. Hüttel <dilfridge@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: perl-functions
# @BLURB: eclass for installing Perl module distributions
# @DESCRIPTION:
# The perl-module eclass is designed to allow easier installation of Perl
# module distributions, and their incorporation into the Gentoo Linux system.
# All exported functions from perl-functions.eclass (inherited here)
# explicitly also belong to the interface of perl-module.eclass.
# If your package does not use any Perl-specific build system (as, e.g.,
# ExtUtils::MakeMaker or Module::Build), we recommend to use perl-functions.eclass
# instead.

case ${EAPI} in
	7)
		inherit multiprocessing perl-functions toolchain-funcs
		PERL_EXPF="src_prepare src_configure src_compile src_test src_install"
		;;
	8)
		inherit multiprocessing perl-functions readme.gentoo-r1 toolchain-funcs
		PERL_EXPF="src_prepare src_configure src_compile src_test src_install"
		;;
	*)
		die "${ECLASS}: EAPI ${EAPI:-0} not supported"
		;;
esac

# @ECLASS_VARIABLE: GENTOO_DEPEND_ON_PERL
# @DEFAULT_UNSET
# @DESCRIPTION:
# This variable controls whether a runtime and build time dependency on
# dev-lang/perl is automatically added by the eclass. It defaults to yes.
# Set to no to disable, set to noslotop to add a perl dependency without
# slot operator. All packages installing into the vendor_perl
# path must use yes here. (EAPI=8 and later) Also adds a test useflag,
# a use-conditional build time dependency on virtual/perl-Test-Simple, and
# the required RESTRICT setting.

# @ECLASS_VARIABLE: PERL_USEDEP
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# An eclass-generated USE-dependency string for the features of the
# installed Perl. While by far not as critical as for Python, this should
# be used to depend at least on Perl packages installing compiled
# (binary) files.
#
# Example use:
# @CODE
# RDEPEND=dev-perl/DBI[${PERL_USEDEP}]
# @CODE
#
# Example value:
# @CODE
# perl_features_debug=,perl_features_ithreads=,perl_features_quadmath=
# @CODE
PERL_USEDEP="perl_features_debug=,perl_features_ithreads=,perl_features_quadmath="

GENTOO_PERL_DEPSTRING=">=dev-lang/perl-5.38.2-r3[${PERL_USEDEP}]"
GENTOO_PERL_USESTRING="perl_features_debug perl_features_ithreads perl_features_quadmath"

case ${EAPI} in
	7)
		[[ ${CATEGORY} == perl-core ]] && \
			PERL_EXPF+=" pkg_postinst pkg_postrm"

		case "${GENTOO_DEPEND_ON_PERL:-yes}" in
			yes)
				IUSE=${GENTOO_PERL_USESTRING}
				DEPEND=${GENTOO_PERL_DEPSTRING}
				BDEPEND=${GENTOO_PERL_DEPSTRING}
				RDEPEND="${GENTOO_PERL_DEPSTRING} dev-lang/perl:="
				;;
			noslotop)
				IUSE=${GENTOO_PERL_USESTRING}
				DEPEND=${GENTOO_PERL_DEPSTRING}
				BDEPEND=${GENTOO_PERL_DEPSTRING}
				RDEPEND=${GENTOO_PERL_DEPSTRING}
				;;
		esac

		if [[ "${GENTOO_DEPEND_ON_PERL_SUBSLOT:-yes}" != "yes" ]]; then
			die "GENTOO_DEPEND_ON_PERL_SUBSLOT=no is banned."
		fi

		if [[ "${PERL_EXPORT_PHASE_FUNCTIONS}" ]]; then
			die "PERL_EXPORT_PHASE_FUNCTIONS is banned."
		fi

		EXPORT_FUNCTIONS ${PERL_EXPF}
		;;
	*)
		[[ ${CATEGORY} == perl-core ]] && \
			PERL_EXPF+=" pkg_postinst pkg_postrm"

		case "${GENTOO_DEPEND_ON_PERL:-yes}" in
			yes|noslotop)
				IUSE=${GENTOO_PERL_USESTRING}
				DEPEND=${GENTOO_PERL_DEPSTRING}
				BDEPEND="${GENTOO_PERL_DEPSTRING}
					 test? ( >=virtual/perl-Test-Simple-1 )"
				IUSE+=" test"
				RESTRICT="!test? ( test )"
				;;&
			yes)
				RDEPEND="${GENTOO_PERL_DEPSTRING} dev-lang/perl:="
				;;
			noslotop)
				RDEPEND=${GENTOO_PERL_DEPSTRING}
				;;
		esac

		if [[ "${GENTOO_DEPEND_ON_PERL_SUBSLOT:-yes}" != "yes" ]]; then
			die "GENTOO_DEPEND_ON_PERL_SUBSLOT=no is banned."
		fi

		if [[ "${PERL_EXPORT_PHASE_FUNCTIONS}" ]]; then
			die "PERL_EXPORT_PHASE_FUNCTIONS is banned."
		fi

		EXPORT_FUNCTIONS ${PERL_EXPF}
		;;
esac

LICENSE="${LICENSE:-|| ( Artistic GPL-1+ )}"

# @ECLASS_VARIABLE: DIST_NAME
# @DEFAULT_UNSET
# @DESCRIPTION:
# This variable provides a way to override PN for the calculation of S,
# SRC_URI, and HOMEPAGE. If unset, defaults to PN.

# @ECLASS_VARIABLE: DIST_VERSION
# @DEFAULT_UNSET
# @DESCRIPTION:
# This variable provides a way to override PV for the calculation of S and SRC_URI.
# Use it to provide the non-normalized, upstream version number. If unset, defaults to PV.

# @ECLASS_VARIABLE: DIST_A_EXT
# @DEFAULT_UNSET
# @DESCRIPTION:
# This variable provides a way to override the distfile extension for the calculation of
# SRC_URI. If unset, defaults to tar.gz.

# @ECLASS_VARIABLE: DIST_A
# @DEFAULT_UNSET
# @DESCRIPTION:
# This variable provides a way to override the distfile name for the calculation of
# SRC_URI. If unset, defaults to ${DIST_NAME}-${DIST_VERSION}.${DIST_A_EXT}.

# @ECLASS_VARIABLE: DIST_AUTHOR
# @DEFAULT_UNSET
# @DESCRIPTION:
# This variable sets the module author name for the calculation of SRC_URI.

# @ECLASS_VARIABLE: DIST_SECTION
# @DEFAULT_UNSET
# @DESCRIPTION:
# This variable sets the module section for the calculation of
# SRC_URI. Only required in rare cases for very special snowflakes.

# @ECLASS_VARIABLE: DIST_EXAMPLES
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# This Bash array allows passing a list of example files to be installed
# in /usr/share/doc/${PF}/examples. If set before inherit, automatically adds
# a use-flag examples, if not you'll have to add the useflag in your ebuild.
# Examples are installed only if the useflag examples exists and is activated.

# @ECLASS_VARIABLE: DIST_WIKI
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=8 and later) This variable can be set to contain space-separated keywords
# corresponding to article sections in a maintenance notes wiki article. If a
# keyword is set, an ebuild phase can output a message and a link to the wiki.
# Current keywords as of EAPI=8 are:
# * features: Notes about additional dependencies for optional features
# * tests:    Notes about additional dependencies and preparations needed for testing

# @ECLASS_VARIABLE: DIST_MAKE
# @DESCRIPTION:
# (EAPI=8 and later) This Bash array contains parameters to the make call
# from ExtUtils::MakeMaker. Replaces mymake in EAPI=7 and earlier.
# Defaults to ( OPTIMIZE="${CFLAGS}" )
if [[ $(declare -p DIST_MAKE 2>&-) != "declare -a DIST_MAKE="* ]]; then
	DIST_MAKE=( OPTIMIZE="${CFLAGS}" )
fi

DIST_NAME=${DIST_NAME:-${PN}}
DIST_P=${DIST_NAME}-${DIST_VERSION:-${PV}}
S=${WORKDIR}/${DIST_P}

[[ -z "${SRC_URI}" && -z "${DIST_A}" ]] &&
	DIST_A="${DIST_P}.${DIST_A_EXT:-tar.gz}"
[[ -z "${SRC_URI}" && -n "${DIST_AUTHOR}" ]] &&
	SRC_URI="mirror://cpan/authors/id/${DIST_AUTHOR:0:1}/${DIST_AUTHOR:0:2}/${DIST_AUTHOR}/${DIST_SECTION:+${DIST_SECTION}/}${DIST_A}"
[[ -z "${HOMEPAGE}" ]] &&
	HOMEPAGE="https://metacpan.org/release/${DIST_NAME}"

[[ -z "${DIST_EXAMPLES}" ]] || IUSE+=" examples"

PREFER_BUILDPL="yes"

pm_echovar=""

# @FUNCTION: perl-module_src_prepare
# @DESCRIPTION:
# Get the ebuild sources ready.
# This function is to be called during the ebuild src_prepare() phase.
perl-module_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	default

	if [[ ${PERL_RM_FILES[@]} ]]; then
		debug-print "$FUNCNAME: stripping unneeded files"
		perl_rm_files "${PERL_RM_FILES[@]}"
	fi
	perl_fix_osx_extra
}

# @FUNCTION: perl-module_src_configure
# @DESCRIPTION:
# Configure the ebuild sources.
# This function is to be called during the ebuild src_configure() phase.
perl-module_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	# Perl runs LD with LDFLAGS
	export CCLD=$(tc-getCC)
	unset LD

	perl_check_env

	perl_set_version

	[[ -z ${pm_echovar} ]] && export PERL_MM_USE_DEFAULT=1
	# Disable ExtUtils::AutoInstall from prompting
	export PERL_EXTUTILS_AUTOINSTALL="--skipdeps"
	# Noisy and not really appropriate to show to the user in a PM
	export PERL_CANARY_STABILITY_DISABLE=1

	if [[ $(declare -p myconf 2>&-) != "declare -a myconf="* ]]; then
		local myconf_local=(${myconf})
	else
		local myconf_local=("${myconf[@]}")
	fi

	if [[ ( ${PREFER_BUILDPL} == yes || ! -f Makefile.PL ) && -f Build.PL ]] ; then
		if grep -q '\(use\|require\)\s*Module::Build::Tiny' Build.PL ; then
			einfo "Using Module::Build::Tiny"
			if [[ ${BDEPEND} != *dev-perl/Module-Build-Tiny* && ${PN} != Module-Build-Tiny ]]; then
				eerror "QA Notice: The ebuild uses Module::Build::Tiny but doesn't depend on it."
				eerror " Add dev-perl/Module-Build-Tiny to BDEPEND!"
			fi
		else
			einfo "Using Module::Build"
			if [[ ${BDEPEND} != *virtual/perl-Module-Build* && ${BDEPEND} != *dev-perl/Module-Build* && ${PN} != Module-Build ]] ; then
				eerror "QA Notice: The ebuild uses Module::Build but doesn't depend on it."
				eerror " Add dev-perl/Module-Build to BDEPEND!"
			fi
		fi

		set -- \
			--installdirs=vendor \
			--libdoc= \
			--create_packlist=1 \
			--config ar="$(tc-getAR)" \
			--config cc="$(tc-getCC)" \
			--config cpp="$(tc-getCPP)" \
			--config ld="$(tc-getCC)" \
			--config nm="$(tc-getNM)" \
			--config ranlib="$(tc-getRANLIB)" \
			--config optimize="${CFLAGS}" \
			--config ldflags="${LDFLAGS}" \
			"${myconf_local[@]}"
		einfo "perl Build.PL" "$@"
		perl Build.PL "$@" <<< "${pm_echovar}" \
				|| die "Unable to build!"
	elif [[ -f Makefile.PL ]] ; then
		einfo "Using ExtUtils::MakeMaker"
		set -- \
			AR="$(tc-getAR)" \
			CC="$(tc-getCC)" \
			CPP="$(tc-getCPP)" \
			LD="$(tc-getCC)" \
			NM="$(tc-getNM)" \
			RANLIB="$(tc-getRANLIB)" \
			OPTIMIZE="${CFLAGS}" \
			LDFLAGS="${LDFLAGS}" \
			PREFIX="${EPREFIX}"/usr \
			INSTALLDIRS=vendor \
			INSTALLMAN3DIR='none' \
			"${myconf_local[@]}"
		einfo "perl Makefile.PL" "$@"
		perl Makefile.PL "$@" <<< "${pm_echovar}" \
				|| die "Unable to build!"
	fi
	if [[ ! -f Build.PL && ! -f Makefile.PL ]] ; then
		einfo "No Make or Build file detected..."
		return
	fi
}

# @FUNCTION: perl-module_src_compile
# @DESCRIPTION:
# Compile the ebuild sources.
# This function is to be called during the ebuild src_compile() phase.
perl-module_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	perl_set_version

	case ${EAPI} in
		7)
			if [[ $(declare -p mymake 2>&-) != "declare -a mymake="* ]]; then
				local mymake_local=(${mymake})
			else
				local mymake_local=("${mymake[@]}")
			fi
			;;
		*)
			local mymake_local=("${DIST_MAKE[@]}")
			;;
	esac

	if [[ -f Build ]] ; then
		./Build build \
			|| die "Compilation failed"
	elif [[ -f Makefile ]] ; then
		set -- \
			OTHERLDFLAGS="${LDFLAGS}" \
			"${mymake_local[@]}"
		emake "$@"
	fi
}

# @ECLASS_VARIABLE: DIST_TEST
# @DEFAULT_UNSET
# @DESCRIPTION:
# Variable that controls if tests are run in the test phase
# at all, and if yes under which conditions. If unset, defaults to "do parallel"
# If neither "do" nor "parallel" is recognized, tests are skipped.
# The following space-separated keywords are recognized:
#   do       : run tests
#   parallel : run tests in parallel
#   verbose  : increase test verbosity
#   network  : do not try to disable network tests

# @ECLASS_VARIABLE: DIST_TEST_OVERRIDE
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Variable that controls if tests are run in the test phase
# at all, and if yes under which conditions. It is intended for use in
# make.conf or the environment by ebuild authors during testing, and
# accepts the same values as DIST_TEST. If set, it overrides DIST_TEST
# completely. DO NOT USE THIS IN EBUILDS!

# @FUNCTION: perl-module_src_test
# @DESCRIPTION:
# This code attempts to work out your threadingness and runs tests
# according to the settings of DIST_TEST using Test::Harness.
perl-module_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	local my_test_control
	local my_test_verbose
	local my_test_makeopts

	[[ -n "${DIST_TEST_OVERRIDE}" ]] && ewarn "DIST_TEST_OVERRIDE is set to ${DIST_TEST_OVERRIDE}"
	my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}

	if ! has 'do' ${my_test_control} && ! has 'parallel' ${my_test_control} ; then
		einfo Skipping tests due to DIST_TEST=${my_test_control}
		return 0
	fi

	if has 'do' ${my_test_control} && ! has 'parallel' ${my_test_control} ; then
		my_test_makeopts="-j1"
	fi

	if has verbose ${my_test_control} ; then
		my_test_verbose=1
	else
		my_test_verbose=0
	fi

	if has parallel ${my_test_control} ; then
		export HARNESS_OPTIONS=j$(makeopts_jobs)
		einfo "Test::Harness Jobs=$(makeopts_jobs)"
	fi

	# this might sometimes work...
	if ! has network ${my_test_control} ; then
		export NO_NETWORK_TESTING=1
	fi

	# See https://www.perlmonks.org/?node_id=1225311
	# * AUTOMATED_TESTING appears inappropriate for us, as it affects
	# exit codes and might mask failures if configuration is wrong.
	# * EXTENDED_TESTING is something we could consider if we had
	# some way to opt-in to expensive tests.
	export NONINTERACTIVE_TESTING=1

	case ${EAPI} in
		7)
			;;
		*)
			if has 'tests' ${DIST_WIKI} ; then
				ewarn "This package may require additional dependencies and/or preparation steps for"
				ewarn "comprehensive testing. For details, see:"
				ewarn "$(perl_get_wikiurl_tests)"
			fi
			;;
	esac

	perl_set_version
	if [[ -f Build ]] ; then
		./Build test verbose=${my_test_verbose} || die "test failed"
	elif [[ -f Makefile ]] ; then
		emake ${my_test_makeopts} test TEST_VERBOSE=${my_test_verbose}
	fi
}

# @FUNCTION: perl-module_src_install
# @DESCRIPTION:
# Install a Perl ebuild.
# This function is to be called during the ebuild src_install() phase.
perl-module_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	perl_set_version

	local f

	if [[ -f Build ]]; then
		mytargets="${mytargets:-install}"
		mbparams="${mbparams:---destdir="${D}" --pure}"
		einfo "./Build ${mytargets} ${mbparams}"
		./Build ${mytargets} ${mbparams} \
			|| die "./Build ${mytargets} ${mbparams} failed"
	elif [[ -f Makefile ]]; then
		case "${CATEGORY}" in
			dev-perl|perl-core) mytargets="pure_install" ;;
			*)                  mytargets="install" ;;
		esac
		if [[ $(declare -p myinst 2>&-) != "declare -a myinst="* ]]; then
			local myinst_local=(${myinst})
		else
			local myinst_local=("${myinst[@]}")
		fi
		emake DESTDIR="${D}" "${myinst_local[@]}" ${mytargets}
	fi

	case ${EAPI} in
		7)
			;;
		*)
			perl_fix_permissions
			;;
	esac

	perl_delete_module_manpages
	perl_delete_localpod
	perl_fix_packlist
	perl_delete_emptybsdir
	perl_remove_temppath

	for f in Change* CHANGES README* TODO FAQ ${mydoc}; do
		[[ -s ${f} ]] && dodoc ${f}
	done

	if in_iuse examples && use examples ; then
		[[ ${#DIST_EXAMPLES[@]} -eq 0 ]] || perl_doexamples "${DIST_EXAMPLES[@]}"
	fi

	perl_link_duallife_scripts

	case ${EAPI} in
		7)
			;;
		*)
			if has 'features' ${DIST_WIKI} ; then
				DISABLE_AUTOFORMATTING=yes
				DOC_CONTENTS="This package may require additional dependencies and/or preparation steps for\n"
				DOC_CONTENTS+="some optional features. For details, see\n"
				DOC_CONTENTS+="$(perl_get_wikiurl_features)"
				einfo
				readme.gentoo_create_doc
				readme.gentoo_print_elog
			fi
			;;
	esac
}

# @FUNCTION: perl-module_pkg_postinst
# @DESCRIPTION:
# This function is to be called during the pkg_postinst() phase. It only does
# useful things for the perl-core category, where it handles the file renaming and symbolic
# links that prevent file collisions for dual-life packages installing scripts.
# In any other category it immediately exits.
perl-module_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${CATEGORY} != perl-core ]] ; then
		eerror "perl-module.eclass: You are calling perl-module_pkg_postinst outside the perl-core category."
		die    "   This does not do anything; the call can be removed."
	fi
	perl_link_duallife_scripts
}

# @FUNCTION: perl-module_pkg_postrm
# @DESCRIPTION:
# This function is to be called during the pkg_postrm() phase. It only does
# useful things for the perl-core category, where it handles the file renaming and symbolic
# links that prevent file collisions for dual-life packages installing scripts.
# In any other category it immediately exits.
perl-module_pkg_postrm() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${CATEGORY} != perl-core ]] ; then
		eerror "perl-module.eclass: You are calling perl-module_pkg_postrm outside the perl-core category."
		die    "   This does not do anything; the call can be removed."
	fi
	perl_link_duallife_scripts
}

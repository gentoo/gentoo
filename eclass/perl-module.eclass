# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: perl-module.eclass
# @MAINTAINER:
# perl@gentoo.org
# @AUTHOR:
# Seemant Kulleen <seemant@gentoo.org>
# Andreas K. Hüttel <dilfridge@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: eclass for installing Perl module distributions
# @DESCRIPTION:
# The perl-module eclass is designed to allow easier installation of Perl
# module distributions, and their incorporation into the Gentoo Linux system.
# All exported functions from perl-functions.eclass (inherited here)
# explicitly also belong to the interface of perl-module.eclass.
# If your package does not use any Perl-specific build system (as, e.g.,
# ExtUtils::MakeMaker or Module::Build), we recommend to use perl-functions.eclass
# instead.

case ${EAPI:-0} in
	5)
		inherit eutils multiprocessing unpacker perl-functions
		PERL_EXPF="src_unpack src_prepare src_configure src_compile src_test src_install"
		;;
	6|7)
		inherit multiprocessing perl-functions
		PERL_EXPF="src_prepare src_configure src_compile src_test src_install"
		;;
	8)
		inherit multiprocessing perl-functions readme.gentoo-r1
		PERL_EXPF="src_prepare src_configure src_compile src_test src_install"
		;;
	*)
		die "EAPI=${EAPI} is not supported by perl-module.eclass"
		;;
esac

# @ECLASS-VARIABLE: GENTOO_DEPEND_ON_PERL
# @DEFAULT_UNSET
# @DESCRIPTION:
# This variable controls whether a runtime and build time dependency on
# dev-lang/perl is automatically added by the eclass. It defaults to yes.
# Set to no to disable, set to noslotop to add a perl dependency without
# slot operator (EAPI=6). All packages installing into the vendor_perl
# path must use yes here.

case ${EAPI:-0} in
	5)
		[[ ${CATEGORY} == perl-core ]] && \
			PERL_EXPF+=" pkg_postinst pkg_postrm"

		case "${GENTOO_DEPEND_ON_PERL:-yes}" in
		yes)
			case "${GENTOO_DEPEND_ON_PERL_SUBSLOT:-yes}" in
			yes)
				DEPEND="dev-lang/perl:=[-build(-)]"
				;;
			*)
				DEPEND="dev-lang/perl[-build(-)]"
				;;
			esac
			RDEPEND="${DEPEND}"
			;;
		esac

		case "${PERL_EXPORT_PHASE_FUNCTIONS:-yes}" in
			yes)
				EXPORT_FUNCTIONS ${PERL_EXPF}
				;;
			no)
				debug-print "PERL_EXPORT_PHASE_FUNCTIONS=no"
				;;
			*)
				die "PERL_EXPORT_PHASE_FUNCTIONS=${PERL_EXPORT_PHASE_FUNCTIONS} is not supported by perl-module.eclass"
				;;
		esac
		;;
	6)
		[[ ${CATEGORY} == perl-core ]] && \
			PERL_EXPF+=" pkg_postinst pkg_postrm"

		case "${GENTOO_DEPEND_ON_PERL:-yes}" in
			yes)
				DEPEND="dev-lang/perl"
				RDEPEND="dev-lang/perl:="
				;;
			noslotop)
				DEPEND="dev-lang/perl"
				RDEPEND="dev-lang/perl"
				;;
		esac

		if [[ "${GENTOO_DEPEND_ON_PERL_SUBSLOT:-yes}" != "yes" ]]; then
			eerror "GENTOO_DEPEND_ON_PERL_SUBSLOT=no is banned in EAPI=6 and later. If you don't want a slot operator"
			die    "set GENTOO_DEPEND_ON_PERL=noslotop instead."
		fi

		if [[ "${PERL_EXPORT_PHASE_FUNCTIONS}" ]]; then
			eerror "PERL_EXPORT_PHASE_FUNCTIONS is banned in EAPI=6 and later. Use perl-module.eclass if you need"
			die    "phase functions, perl-functions.eclass if not."
		fi

		EXPORT_FUNCTIONS ${PERL_EXPF}
		;;
	*)
		[[ ${CATEGORY} == perl-core ]] && \
			PERL_EXPF+=" pkg_postinst pkg_postrm"

		case "${GENTOO_DEPEND_ON_PERL:-yes}" in
			yes)
				DEPEND="dev-lang/perl"
				BDEPEND="dev-lang/perl"
				RDEPEND="dev-lang/perl:="
				;;
			noslotop)
				DEPEND="dev-lang/perl"
				BDEPEND="dev-lang/perl"
				RDEPEND="dev-lang/perl"
				;;
		esac

		if [[ "${GENTOO_DEPEND_ON_PERL_SUBSLOT:-yes}" != "yes" ]]; then
			die "GENTOO_DEPEND_ON_PERL_SUBSLOT=no is banned in EAPI=6 and later."
		fi

		if [[ "${PERL_EXPORT_PHASE_FUNCTIONS}" ]]; then
			die "PERL_EXPORT_PHASE_FUNCTIONS is banned in EAPI=6 and later."
		fi

		EXPORT_FUNCTIONS ${PERL_EXPF}
		;;
esac

LICENSE="${LICENSE:-|| ( Artistic GPL-1+ )}"

# @ECLASS-VARIABLE: DIST_NAME
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6 and later) This variable provides a way to override PN for the calculation of S,
# SRC_URI, and HOMEPAGE. If unset, defaults to PN.

# @ECLASS-VARIABLE: DIST_VERSION
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6 and later) This variable provides a way to override PV for the calculation of S and SRC_URI.
# Use it to provide the non-normalized, upstream version number. If unset, defaults to PV.
# Named MODULE_VERSION in EAPI=5.

# @ECLASS-VARIABLE: DIST_A_EXT
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6 and later) This variable provides a way to override the distfile extension for the calculation of
# SRC_URI. If unset, defaults to tar.gz. Named MODULE_A_EXT in EAPI=5.

# @ECLASS-VARIABLE: DIST_A
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6 and later) This variable provides a way to override the distfile name for the calculation of
# SRC_URI. If unset, defaults to ${DIST_NAME}-${DIST_VERSION}.${DIST_A_EXT} Named MODULE_A in EAPI=5.

# @ECLASS-VARIABLE: DIST_AUTHOR
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6 and later) This variable sets the module author name for the calculation of
# SRC_URI. Named MODULE_AUTHOR in EAPI=5.

# @ECLASS-VARIABLE: DIST_SECTION
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6 and later) This variable sets the module section for the calculation of
# SRC_URI. Only required in rare cases for very special snowflakes.
# Named MODULE_SECTION in EAPI=5.

# @ECLASS-VARIABLE: DIST_EXAMPLES
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6 and later) This Bash array allows passing a list of example files to be installed
# in /usr/share/doc/${PF}/examples. If set before inherit, automatically adds
# a use-flag examples, if not you'll have to add the useflag in your ebuild.
# Examples are installed only if the useflag examples exists and is activated.

# @ECLASS-VARIABLE: DIST_WIKI
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=8 and later) This variable can be set to contain space-separated keywords
# corresponding to article sections in a maintenance notes wiki article. If a
# keyword is set, an ebuild phase can output a message and a link to the wiki.
# Current keywords as of EAPI=8 are:
# * features: Notes about additional dependencies for optional features
# * tests:    Notes about additional dependencies and preparations needed for testing

# @ECLASS-VARIABLE: DIST_MAKE
# @DESCRIPTION:
# (EAPI=8 and later) This Bash array contains parameters to the make call
# from ExtUtils::MakeMaker. Replaces mymake in EAPI=7 and earlier.
# Defaults to ( OPTIMIZE="${CFLAGS}" )
if [[ $(declare -p DIST_MAKE 2>&-) != "declare -a DIST_MAKE="* ]]; then
	DIST_MAKE=( OPTIMIZE="${CFLAGS}" )
fi


if [[ ${EAPI:-0} == 5 ]]; then
	if [[ -n ${MY_PN} || -n ${MY_PV} || -n ${MODULE_VERSION} ]] ; then
		: ${MY_P:=${MY_PN:-${PN}}-${MY_PV:-${MODULE_VERSION:-${PV}}}}
		S=${MY_S:-${WORKDIR}/${MY_P}}
	fi
	MODULE_NAME=${MY_PN:-${PN}}
	MODULE_P=${MY_P:-${P}}

	[[ -z "${SRC_URI}" && -z "${MODULE_A}" ]] && \
		MODULE_A="${MODULE_P}.${MODULE_A_EXT:-tar.gz}"
	[[ -z "${SRC_URI}" && -n "${MODULE_AUTHOR}" ]] && \
		SRC_URI="mirror://cpan/authors/id/${MODULE_AUTHOR:0:1}/${MODULE_AUTHOR:0:2}/${MODULE_AUTHOR}/${MODULE_SECTION:+${MODULE_SECTION}/}${MODULE_A}"
	[[ -z "${HOMEPAGE}" ]] && \
		HOMEPAGE="https://metacpan.org/release/${MODULE_NAME}"

	SRC_TEST="skip"
else
	DIST_NAME=${DIST_NAME:-${PN}}
	DIST_P=${DIST_NAME}-${DIST_VERSION:-${PV}}
	S=${WORKDIR}/${DIST_P}

	[[ -z "${SRC_URI}" && -z "${DIST_A}" ]] && \
		DIST_A="${DIST_P}.${DIST_A_EXT:-tar.gz}"
	[[ -z "${SRC_URI}" && -n "${DIST_AUTHOR}" ]] && \
		SRC_URI="mirror://cpan/authors/id/${DIST_AUTHOR:0:1}/${DIST_AUTHOR:0:2}/${DIST_AUTHOR}/${DIST_SECTION:+${DIST_SECTION}/}${DIST_A}"
	[[ -z "${HOMEPAGE}" ]] && \
		HOMEPAGE="https://metacpan.org/release/${DIST_NAME}"

	[[ -z "${DIST_EXAMPLES}" ]] || IUSE+=" examples"
fi

SRC_PREP="no"
PREFER_BUILDPL="yes"

pm_echovar=""

# @FUNCTION: perl-module_src_unpack
# @DESCRIPTION:
# Unpack the ebuild tarball(s).
# This function is to be called during the ebuild src_unpack() phase.
perl-module_src_unpack() {
	debug-print-function $FUNCNAME "$@"
	[[ ${EAPI:-0} == 5 ]] || die "perl-module_src_unpack is banned in EAPI=6 or later"
	unpacker_src_unpack
}

# @FUNCTION: perl-module_src_prepare
# @DESCRIPTION:
# Get the ebuild sources ready.
# This function is to be called during the ebuild src_prepare() phase.
perl-module_src_prepare() {
	debug-print-function $FUNCNAME "$@"

	if [[ ${EAPI:-0} == 5 ]] ; then
		[[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
		debug-print "$FUNCNAME: applying user patches"
		epatch_user
	else
		default
	fi

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
	debug-print-function $FUNCNAME "$@"

	if [[ ${EAPI:-0} == 5 && ${SRC_PREP} == yes ]]; then
		return 0
	fi
	SRC_PREP="yes"

	perl_check_env

	perl_set_version

	[[ -z ${pm_echovar} ]] && export PERL_MM_USE_DEFAULT=1
	# Disable ExtUtils::AutoInstall from prompting
	export PERL_EXTUTILS_AUTOINSTALL="--skipdeps"

	if [[ $(declare -p myconf 2>&-) != "declare -a myconf="* ]]; then
		local myconf_local=(${myconf})
	else
		local myconf_local=("${myconf[@]}")
	fi

	if [[ ( ${PREFER_BUILDPL} == yes || ! -f Makefile.PL ) && -f Build.PL ]] ; then
		case ${EAPI:-0} in
			5|6)
				if grep -q '\(use\|require\)\s*Module::Build::Tiny' Build.PL ; then
					einfo "Using Module::Build::Tiny"
					if [[ ${DEPEND} != *dev-perl/Module-Build-Tiny* && ${PN} != Module-Build-Tiny ]]; then
						eerror "QA Notice: The ebuild uses Module::Build::Tiny but doesn't depend on it."
						die    " Add dev-perl/Module-Build-Tiny to DEPEND!"
					fi
				else
					einfo "Using Module::Build"
					if [[ ${DEPEND} != *virtual/perl-Module-Build* && ${DEPEND} != *dev-perl/Module-Build* && ${PN} != Module-Build ]] ; then
						eerror "QA Notice: The ebuild uses Module::Build but doesn't depend on it."
						die    " Add dev-perl/Module-Build to DEPEND!"
					fi
				fi
				;;
			*)
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
				;;
		esac
		set -- \
			--installdirs=vendor \
			--libdoc= \
			--destdir="${D}" \
			--create_packlist=1 \
			"${myconf_local[@]}"
		einfo "perl Build.PL" "$@"
		perl Build.PL "$@" <<< "${pm_echovar}" \
				|| die "Unable to build!"
	elif [[ -f Makefile.PL ]] ; then
		einfo "Using ExtUtils::MakeMaker"
		set -- \
			PREFIX=${EPREFIX}/usr \
			INSTALLDIRS=vendor \
			INSTALLMAN3DIR='none' \
			DESTDIR="${D}" \
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
	debug-print-function $FUNCNAME "$@"
	perl_set_version

	case ${EAPI} in
		5|6|7)
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
		einfo "emake" "$@"
		emake "$@" \
			|| die "Compilation failed"
#			OPTIMIZE="${CFLAGS}" \
	fi
}

# @ECLASS-VARIABLE: DIST_TEST
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6 and later) Variable that controls if tests are run in the test phase
# at all, and if yes under which conditions. If unset, defaults to "do parallel"
# If neither "do" nor "parallel" is recognized, tests are skipped.
# (In EAPI=5 the variable is called SRC_TEST, defaults to "skip", and
# recognizes fewer options.)
# The following space-separated keywords are recognized:
#   do       : run tests
#   parallel : run tests in parallel
#   verbose  : increase test verbosity
#   network  : do not try to disable network tests

# @ECLASS-VARIABLE: DIST_TEST_OVERRIDE
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6 and later) Variable that controls if tests are run in the test phase
# at all, and if yes under which conditions. It is intended for use in
# make.conf or the environment by ebuild authors during testing, and
# accepts the same values as DIST_TEST. If set, it overrides DIST_TEST
# completely. DO NOT USE THIS IN EBUILDS!

# @FUNCTION: perl-module_src-test
# @DESCRIPTION:
# This code attempts to work out your threadingness and runs tests
# according to the settings of DIST_TEST using Test::Harness.
perl-module_src_test() {
	debug-print-function $FUNCNAME "$@"
	local my_test_control
	local my_test_verbose

	if [[ ${EAPI} == 5 ]] ; then
		my_test_control=${SRC_TEST}
		my_test_verbose=${TEST_VERBOSE:-0}
		if has 'do' ${my_test_control} || has 'parallel' ${my_test_control} ; then
			if has "${my_test_verbose}" 0 && has 'parallel' ${my_test_control} ; then
				export HARNESS_OPTIONS=j$(makeopts_jobs)
				einfo "Test::Harness Jobs=$(makeopts_jobs)"
			fi
		else
			einfo Skipping tests due to SRC_TEST=${SRC_TEST}
			return 0
		fi
	else
		[[ -n "${DIST_TEST_OVERRIDE}" ]] && ewarn DIST_TEST_OVERRIDE is set to ${DIST_TEST_OVERRIDE}
		my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}

		if ! has 'do' ${my_test_control} && ! has 'parallel' ${my_test_control} ; then
			einfo Skipping tests due to DIST_TEST=${my_test_control}
			return 0
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
	fi

	case ${EAPI} in
		5|6|7)
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
		emake test TEST_VERBOSE=${my_test_verbose} || die "test failed"
	fi
}

# @FUNCTION: perl-module_src_install
# @DESCRIPTION:
# Install a Perl ebuild.
# This function is to be called during the ebuild src_install() phase.
perl-module_src_install() {
	debug-print-function $FUNCNAME "$@"

	perl_set_version

	local f

	if [[ -f Build ]]; then
		mytargets="${mytargets:-install}"
		mbparams="${mbparams:---pure}"
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
		emake "${myinst_local[@]}" ${mytargets} \
			|| die "emake ${myinst_local[@]} ${mytargets} failed"
	fi

	case ${EAPI} in
		5|6|7)
			;;
		*)
			perl_fix_permissions
			;;
	esac

	perl_delete_module_manpages
	perl_delete_localpod
	if [[ ${EAPI} == 5 ]] ; then
		perl_delete_packlist
	else
		perl_fix_packlist
		perl_delete_emptybsdir
	fi
	perl_remove_temppath

	for f in Change* CHANGES README* TODO FAQ ${mydoc}; do
		[[ -s ${f} ]] && dodoc ${f}
	done

	if [[ ${EAPI} != 5 ]] ; then
		if in_iuse examples && use examples ; then
                        [[ ${#DIST_EXAMPLES[@]} -eq 0 ]] || perl_doexamples "${DIST_EXAMPLES[@]}"
		fi
	fi

	perl_link_duallife_scripts

	case ${EAPI} in
		5|6|7)
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
	debug-print-function $FUNCNAME "$@"
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
	debug-print-function $FUNCNAME "$@"
	if [[ ${CATEGORY} != perl-core ]] ; then
		eerror "perl-module.eclass: You are calling perl-module_pkg_postrm outside the perl-core category."
		die    "   This does not do anything; the call can be removed."
	fi
	perl_link_duallife_scripts
}

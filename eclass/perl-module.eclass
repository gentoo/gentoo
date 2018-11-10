# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: perl-module.eclass
# @MAINTAINER:
# perl@gentoo.org
# @AUTHOR:
# Seemant Kulleen <seemant@gentoo.org>
# Andreas K. Hüttel <dilfridge@gentoo.org>
# @SUPPORTED_EAPIS: 5 6
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
	6)
		inherit multiprocessing perl-functions
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
				DEPEND="dev-lang/perl:="
				RDEPEND="dev-lang/perl:="
				;;
			noslotop)
				DEPEND="dev-lang/perl"
				RDEPEND="dev-lang/perl"
				;;
		esac

		if [[ "${GENTOO_DEPEND_ON_PERL_SUBSLOT:-yes}" != "yes" ]]; then
			eerror "GENTOO_DEPEND_ON_PERL_SUBSLOT=no is banned in EAPI=6. If you don't want a slot operator"
			die    "set GENTOO_DEPEND_ON_PERL=noslotop instead."
		fi

		if [[ "${PERL_EXPORT_PHASE_FUNCTIONS}" ]]; then
			eerror "PERL_EXPORT_PHASE_FUNCTIONS is banned in EAPI=6. Use perl-module.eclass if you need"
			die    "phase functions, perl-functions.eclass if not."
		fi

		EXPORT_FUNCTIONS ${PERL_EXPF}
		;;
	*)
		die "EAPI=${EAPI:-0} is not supported by perl-module.eclass"
		;;
esac

LICENSE="${LICENSE:-|| ( Artistic GPL-1+ )}"

# @ECLASS-VARIABLE: DIST_NAME
# @DESCRIPTION:
# (EAPI=6) This variable provides a way to override PN for the calculation of S,
# SRC_URI, and HOMEPAGE. Defaults to PN.

# @ECLASS-VARIABLE: DIST_VERSION
# @DESCRIPTION:
# (EAPI=6) This variable provides a way to override PV for the calculation of S and SRC_URI.
# Use it to provide the non-normalized, upstream version number. Defaults to PV.
# Named MODULE_VERSION in EAPI=5.

# @ECLASS-VARIABLE: DIST_A_EXT
# @DESCRIPTION:
# (EAPI=6) This variable provides a way to override the distfile extension for the calculation of
# SRC_URI. Defaults to tar.gz. Named MODULE_A_EXT in EAPI=5.

# @ECLASS-VARIABLE: DIST_A
# @DESCRIPTION:
# (EAPI=6) This variable provides a way to override the distfile name for the calculation of
# SRC_URI. Defaults to ${DIST_NAME}-${DIST_VERSION}.${DIST_A_EXT} Named MODULE_A in EAPI=5.

# @ECLASS-VARIABLE: DIST_AUTHOR
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6) This variable sets the module author name for the calculation of
# SRC_URI. Named MODULE_AUTHOR in EAPI=5.

# @ECLASS-VARIABLE: DIST_SECTION
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6) This variable sets the module section for the calculation of
# SRC_URI. Only required in rare cases for very special snowflakes.
# Named MODULE_SECTION in EAPI=5.

# @ECLASS-VARIABLE: DIST_EXAMPLES
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6) This Bash array allows passing a list of example files to be installed
# in /usr/share/doc/${PF}/examples. If set before inherit, automatically adds
# a use-flag examples, if not you'll have to add the useflag in your ebuild.
# Examples are installed only if the useflag examples exists and is activated.


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
		HOMEPAGE="http://metacpan.org/release/${DIST_NAME}"

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

	if [[ $(declare -p mymake 2>&-) != "declare -a mymake="* ]]; then
		local mymake_local=(${mymake})
	else
		local mymake_local=("${mymake[@]}")
	fi

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
# @DESCRIPTION:
# (EAPI=6) Variable that controls if tests are run in the test phase
# at all, and if yes under which conditions. Defaults to "do parallel"
# If neither "do" nor "parallel" is recognized, tests are skipped.
# (In EAPI=5 the variable is called SRC_TEST, defaults to "skip", and
# recognizes fewer options.)
# The following space-separated keywords are recognized:
#   do       : run tests
#   parallel : run tests in parallel
#   verbose  : increase test verbosity
#   network  : do not try to disable network tests

# @ECLASS-VARIABLE: DIST_TEST_OVERRIDE
# @DEFAULT_UNSET
# @DESCRIPTION:
# (EAPI=6) Variable that controls if tests are run in the test phase
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

	if [[ ${EAPI:-0} == 5 ]] ; then
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

	perl_delete_module_manpages
	perl_delete_localpod
	if [[ ${EAPI:-0} == 5 ]] ; then
		perl_delete_packlist
	else
		perl_fix_packlist
		perl_delete_emptybsdir
	fi
	perl_remove_temppath

	for f in Change* CHANGES README* TODO FAQ ${mydoc}; do
		[[ -s ${f} ]] && dodoc ${f}
	done

	if [[ ${EAPI:-0} != 5 ]] ; then
		if in_iuse examples && use examples ; then
                        [[ ${#DIST_EXAMPLES[@]} -eq 0 ]] || perl_doexamples "${DIST_EXAMPLES[@]}"
		fi
	fi

	perl_link_duallife_scripts
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

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: perl-functions.eclass
# @MAINTAINER:
# perl@gentoo.org
# @AUTHOR:
# Seemant Kulleen <seemant@gentoo.org>
# Andreas K. Huettel <dilfridge@gentoo.org>
# Kent Fredric <kentnl@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: helper functions eclass for perl modules
# @DESCRIPTION:
# The perl-functions eclass is designed to allow easier installation of perl
# modules, and their incorporation into the Gentoo Linux system.
# It provides helper functions, no phases or variable manipulation in
# global scope.

[[ ${CATEGORY} == "perl-core" ]] && inherit alternatives

case "${EAPI:-0}" in
	5|6|7)
		;;
	*)
		die "EAPI=${EAPI} is not supported by perl-functions.eclass"
		;;
esac

perlinfo_done=false

# @FUNCTION: perl_set_version
# @DESCRIPTION:
# Extract version information and installation paths from the current Perl
# interpreter.
#
# This sets the following variables: PERL_VERSION, SITE_ARCH, SITE_LIB,
# ARCH_LIB, VENDOR_LIB, VENDOR_ARCH
#
# This function used to be called perlinfo as well.
#
# Example:
# @CODE
# perl_set_version
# echo $PERL_VERSION
# @CODE
perl_set_version() {
	debug-print-function $FUNCNAME "$@"
	debug-print "$FUNCNAME: perlinfo_done=${perlinfo_done}"
	${perlinfo_done} && return 0
	perlinfo_done=true

	local f version install{{site,vendor}{arch,lib},archlib}
	eval "$(perl -V:{version,install{{site,vendor}{arch,lib},archlib}} )"
	PERL_VERSION=${version}
	SITE_ARCH=${installsitearch}
	SITE_LIB=${installsitelib}
	ARCH_LIB=${installarchlib}
	VENDOR_LIB=${installvendorlib}
	VENDOR_ARCH=${installvendorarch}
}

# @FUNCTION: perl_delete_localpod
# @DESCRIPTION:
# Remove stray perllocal.pod files in the temporary install directory D.
#
# This function used to be called fixlocalpod as well.
perl_delete_localpod() {
	debug-print-function $FUNCNAME "$@"

	find "${D}" -type f -name perllocal.pod -delete
	find "${D}" -depth -mindepth 1 -type d -empty -delete
}

# @FUNCTION: perl_fix_osx_extra
# @DESCRIPTION:
# Look through ${S} for AppleDouble encoded files and get rid of them.
perl_fix_osx_extra() {
	debug-print-function $FUNCNAME "$@"

	local f
	find "${S}" -type f -name "._*" -print0 | while read -rd '' f ; do
		einfo "Removing AppleDouble encoded Macintosh file: ${f#${S}/}"
		rm -f "${f}"
		f=${f#${S}/}
		grep -q "${f}" "${S}"/MANIFEST && \
			elog "AppleDouble encoded Macintosh file in MANIFEST: ${f#${S}/}"
	done
}

# @FUNCTION: perl_delete_module_manpages
# @DESCRIPTION:
# Bump off manpages installed by the current module such as *.3pm files as well
# as empty directories.
perl_delete_module_manpages() {
	debug-print-function $FUNCNAME "$@"

	if [[ -d "${ED}"/usr/share/man ]] ; then
		find "${ED}"/usr/share/man -type f -name "*.3pm" -delete
		find "${ED}"/usr/share/man -depth -type d -empty -delete
	fi
}

# @FUNCTION: perl_delete_packlist
# @DESCRIPTION:
# Look through ${D} for .packlist files, empty .bs files and empty directories,
# and get rid of items found.
perl_delete_packlist() {
	debug-print-function $FUNCNAME "$@"
	perl_set_version
	if [[ -d ${D}/${VENDOR_ARCH} ]] ; then
		find "${D}/${VENDOR_ARCH}" -type f -a -name .packlist -delete
		perl_delete_emptybsdir
	fi
}

# @FUNCTION: perl_delete_emptybsdir
# @DESCRIPTION:
# Look through ${D} for empty .bs files and empty directories,
# and get rid of items found.
perl_delete_emptybsdir() {
	debug-print-function $FUNCNAME "$@"
	perl_set_version
	if [[ -d ${D}/${VENDOR_ARCH} ]] ; then
		find "${D}/${VENDOR_ARCH}" -type f \
			-a -name '*.bs' -a -empty -delete
		find "${D}" -depth -mindepth 1 -type d -empty -delete
	fi
}

# @FUNCTION: perl_fix_packlist
# @DESCRIPTION:
# Look through ${D} for .packlist text files containing the temporary installation
# folder (i.e. ${D}). If the pattern is found, silently replace it with `/'.
# Remove duplicate entries; then validate all entries in the packlist against ${D}
# and prune entries that do not correspond to installed files.
perl_fix_packlist() {
	debug-print-function $FUNCNAME "$@"

	local packlist_temp="${T}/.gentoo_packlist_temp"
	find "${D}" -type f -name '.packlist' -print0 | while read -rd '' f ; do
		if file "${f}" | grep -q -i " text" ; then
                        einfo "Fixing packlist file /${f#${D}}"

			# remove the temporary build dir path
			sed -i -e "s:${D%/}/:/:g" "${f}"

			# remove duplicate entries
			sort -u "${f}" > "${packlist_temp}"
			mv "${packlist_temp}" "${f}"

			# remove files that dont exist
			cat "${f}" | while read -r entry; do
				if [ ! -e "${D}/${entry}" ]; then
					einfo "Pruning surplus packlist entry ${entry}"
					grep -v -x -F "${entry}" "${f}" > "${packlist_temp}"
					mv "${packlist_temp}" "${f}"
				fi
			done
		fi
	done
}

# @FUNCTION: perl_remove_temppath
# @DESCRIPTION:
# Look through ${D} for text files containing the temporary installation
# folder (i.e. ${D}). If the pattern is found, replace it with `/' and warn.
perl_remove_temppath() {
	debug-print-function $FUNCNAME "$@"

	find "${D}" -type f -not -name '*.so' -print0 | while read -rd '' f ; do
		if file "${f}" | grep -q -i " text" ; then
			grep -q "${D}" "${f}" && ewarn "QA: File contains a temporary path ${f}"
			sed -i -e "s:${D%/}/:/:g" "${f}"
		fi
	done
}

# @FUNCTION: perl_rm_files
# @USAGE: <list of files>
# @DESCRIPTION:
# Remove certain files from a Perl release and remove them from the MANIFEST
# while we're there.
#
# Most useful in src_prepare for nuking bad tests, and is highly recommended
# for any tests like 'pod.t', 'pod-coverage.t' or 'kwalitee.t', as what they
# test is completely irrelevant to end users, and frequently fail simply
# because the authors of Test::Pod... changed their recommendations, and thus
# failures are only useful feedback to Authors, not users.
#
# Removing from MANIFEST also avoids needless log messages warning
# users about files "missing from their kit".
#
# Example:
# @CODE
# src_test() {
#   perl_rm_files t/pod{,-coverage}.t
#   perl-module_src_test
# }
# @CODE
perl_rm_files() {
	debug-print-function $FUNCNAME "$@"
	local skipfile="${T}/.gentoo_makefile_skip"
	local manifile="${S}/MANIFEST"
	local manitemp="${T}/.gentoo_manifest_temp"
	oldifs="$IFS"
	IFS="\n"
	for filename in "$@"; do
		einfo "Removing un-needed ${filename}";
		# Remove the file
		rm -f "${S}/${filename}"
		[[ -e "${manifile}" ]] && echo "${filename}" >> "${skipfile}"
	done
	if [[ -e "${manifile}" && -e "${skipfile}" ]]; then
		einfo "Fixing Manifest"
		grep -v -F -f "${skipfile}" "${manifile}" > "${manitemp}"
		mv -f -- "${manitemp}" "${manifile}"
		rm -- "${skipfile}";
	fi
	IFS="$oldifs"
}

# @FUNCTION: perl_link_duallife_scripts
# @DESCRIPTION:
# Moves files and generates symlinks so dual-life packages installing scripts do not
# lead to file collisions. Mainly for use in pkg_postinst and pkg_postrm, and makes
# only sense for perl-core packages.
perl_link_duallife_scripts() {
	debug-print-function $FUNCNAME "$@"
	if [[ ${CATEGORY} != perl-core ]] || ! has_version ">=dev-lang/perl-5.8.8-r8" ; then
		return 0
	fi

	local i ff
	if has "${EBUILD_PHASE:-none}" "postinst" "postrm" ; then
		for i in "${DUALLIFESCRIPTS[@]}" ; do
			alternatives_auto_makesym "/${i}" "/${i}-[0-9]*"
		done
		for i in "${DUALLIFEMAN[@]}" ; do
			ff=`echo "${EROOT}"/${i%.1}-${PV}-${P}.1*`
			ff=${ff##*.1}
			alternatives_auto_makesym "/${i}${ff}" "/${i%.1}-[0-9]*"
		done
	else
		pushd "${ED}" > /dev/null
		for i in $(find usr/bin -maxdepth 1 -type f 2>/dev/null) ; do
			mv ${i}{,-${PV}-${P}} || die
			#DUALLIFESCRIPTS[${#DUALLIFESCRIPTS[*]}]=${i##*/}
			DUALLIFESCRIPTS[${#DUALLIFESCRIPTS[*]}]=${i}
		done
		for i in $(find usr/share/man/man1 -maxdepth 1 -type f 2>/dev/null) ; do
			mv ${i} ${i%.1}-${PV}-${P}.1 || die
			DUALLIFEMAN[${#DUALLIFEMAN[*]}]=${i}
		done
		popd > /dev/null
	fi
}

# @FUNCTION: perl_check_env
# @DESCRIPTION:
# Checks a blacklist of known-suspect ENV values that can be accidentally set by users
# doing personal perl work, which may accidentally leak into portage and break the
# system perl installaton.
# Dies if any of the suspect fields are found, and tell the user what needs to be unset.
# There's a workaround, but you'll have to read the code for it.
perl_check_env() {
	local errored value;

	for i in PERL_MM_OPT PERL5LIB PERL5OPT PERL_MB_OPT PERL_CORE PERLPREFIX; do
		# Next unless match
		[ -v $i ] || continue;

		# Warn only once, and warn only when one of the bad values are set.
		# record failure here.
		if [ ${errored:-0} == 0 ]; then
			if [ -n "${I_KNOW_WHAT_I_AM_DOING}" ]; then
				elog "perl-module.eclass: Suspicious environment values found.";
			else
				eerror "perl-module.eclass: Suspicious environment values found.";
			fi
		fi
		errored=1

		# Read ENV Value
		value=${!i};

		# Print ENV name/value pair
		if [ -n "${I_KNOW_WHAT_I_AM_DOING}" ]; then
			elog "    $i=\"$value\"";
		else
			eerror "    $i=\"$value\"";
		fi
	done

	# Return if there were no failures
	[ ${errored:-0} == 0 ] && return;

	# Return if user knows what they're doing
	if [ -n "${I_KNOW_WHAT_I_AM_DOING}" ]; then
		elog "Continuing anyway, seems you know what you're doing."
		return
	fi

	eerror "Your environment settings may lead to undefined behavior and/or build failures."
	die "Please fix your environment ( ~/.bashrc, package.env, ... ), see above for details."
}

# @FUNCTION: perl_doexamples
# @USAGE: <list of files or globs>
# @DESCRIPTION:
# Install example files ready-to-run.
# Is called under certain circumstances in perl-module.eclass src_install
# (see the documentation there).
#
# Example:
# @CODE
# src_install() {
#   perl-module_src_install
#   use examples && perl_doexamples "eg/*"
# }
# @CODE
perl_doexamples() {
	debug-print-function $FUNCNAME "$@"

	einfo "Installing examples into /usr/share/doc/${PF}/examples"

	# no compression since we want ready-to-run scripts
	docompress -x /usr/share/doc/${PF}/examples

	docinto examples/
	# Lack of quoting here is important in order to support glob expansion
	# in DIST_EXAMPLES=( ), which is defined before source extraction occurs
	dodoc -r $@

	# is there a way to undo "docinto" ?
}

# @FUNCTION: perl_has_module
# @USAGE: <module name>
# @RETURN: 0 if available, non-zero otherwise
# @DESCRIPTION:
# Query the installed system Perl to see if a given module is installed.
# This does **not** load the module in question, only anticipates if it *might* load.
#
# This is primarily for the purposes of dependency weakening so that conditional
# behaviour can be triggered without adding dependencies to portage which would confuse
# a dependency resolver.
#
# returns 'true' if the module is available, returns error if the module is not available
#
# Example:
# @CODE
# perl_has_module "Test::Tester" && echo "Test::Tester installed"
# @CODE

perl_has_module() {
	debug-print-function $FUNCNAME "$@"

	[[ $# -gt 0 ]] || die "${FUNCNAME}: No module name provided"
	[[ $# -lt 2 ]] || die "${FUNCNAME}: Too many parameters ($#)"

	perl -we 'my $mn = $ARGV[0];
		$mn =~ s{(::|\x{27})}{/}g;
		for(@INC){
			next if ref $_;
			exit 0 if -r $_ . q[/] . $mn . q[.pm]
		}
		exit 1' "$@";
}

# @FUNCTION: perl_has_module_version
# @USAGE: <module name> <minimum upstream version>
# @RETURN: 0 if satisfied, non-zero otherwise
# @DESCRIPTION:
# Query the installed system Perl to see if a given module is installed
# and is at least a given version.
#
# This requires more caution to use than perl_has_module as it requires
# loading the module in question to determine version compatibility,
# which can be SLOW, and can have side effects (ie: compilation fails in
# require due to some dependency, resulting in a "Fail")
#
# Also take care to note the module version is a *minimum*, *must* be
# written in upstream versions format and should be a a legal upstream version
#
# returns a true exit code if the module is both available and is at least
# the specified version
#
# Example:
# @CODE
# perl_has_module_version "Test::Tester" "0.017" \
#	&& echo "Test::Tester 0.017 or greater installed"
# @CODE
perl_has_module_version() {
	debug-print-function $FUNCNAME "$@"

	[[ $# -gt 0 ]] || die "${FUNCNAME}: No module name provided"
	[[ $# -gt 1 ]] || die "${FUNCNAME}: No module version provided"
	[[ $# -lt 3 ]] || die "${FUNCNAME}: Too many parameters ($#)"

	perl -we 'my $mn = $ARGV[0];
		$mn =~ s{(::|\x{27})}{/}g;
		exit ( eval {
			require qq[${mn}.pm];
			$ARGV[0]->VERSION($ARGV[1]);
			1
		} ? 0 : 1 )' "$@"
}

# @FUNCTION: perl_get_module_version
# @USAGE: <module name>
# @RETURN: 0 if module available, non-zero if error
# @DESCRIPTION:
# Query the installed system perl to report the version of the installed
# module.
#
# Note this should be strictly for diagnostic purposes to the end user,
# and may be of selective use in pkg_info to enhance
# emerge --info reports.
#
# Anything that does version comparisons **must not** use the return value
# from this function
#
# Also note that this **must** at least attempt load the module in
# question as part of its operation, and is subsequently prone to SLOWness.
#
# Return codes return error in both compilation-failure and not-installed cases.
#
# Example:
# @CODE
# MODVER=$(perl_get_module_version "Test::Simple") \
#	|| die "Test::Simple not installed: $MODVER"
# @CODE

perl_get_module_version() {
	debug-print-function $FUNCNAME "$@"

	[[ $# -gt 0 ]] || die "${FUNCNAME}: No module name provided"
	[[ $# -lt 2 ]] || die "${FUNCNAME}: Too many parameters ($#)"

	if ! perl_has_module "$@" ; then
		echo "(Not Installed)";
		return 1;
	fi

	# Todo: What do we do if require fails? spew to stderr
	# or stay silent?

	perl -we 'my $mn = $ARGV[0];
		$mn =~ s{(::|\x{27})}{/}g;
		local $@;
		eval { require qq[${mn}.pm]; 1 } or do {
			print q[(Compilation failed in require)];
			exit 1;
		};
		my $stash = \%{ $ARGV[0] . q[::] };
		if ( not exists $stash->{VERSION} ) {
			print q[(No VERSION property)];
			exit 0;
		}
		if ( not defined ${$stash->{VERSION}} ) {
			print q[(undef)];
			exit 0;
		}
		print ${$stash->{VERSION}};
		exit 0; ' "$@"
}

# @FUNCTION: perl_get_raw_vendorlib
# @DESCRIPTION:
# Convenience function to optimise for a common case without double-handling
# variables everywhere.
#
# Note: Will include EPREFIX where relevant
#
# Example:
# @CODE
# my_raw_vendorlib="$(perl_get_raw_vendorlib)"
# @CODE

perl_get_raw_vendorlib() {
	debug-print-function $FUNCNAME "$@"

	[[ $# -lt 1 ]] || die "${FUNCNAME}: Too many parameters ($#)"

	perl -MConfig \
		-e'exists $Config{$ARGV[0]} || die qq{No such Config key "$ARGV[0]"};
		   print $Config{$ARGV[0]};
		   exit 0' -- "installvendorlib" || die "Can't extract installvendorlib from Perl Configuration"
}

# @FUNCTION: perl_get_vendorlib
# @DESCRIPTION:
# Convenience helper for returning Perls' vendor install root
# without EPREFIXing.
#
# Example:
# @CODE
# my_vendorlib="$(perl_get_vendorlib)"
# @CODE

perl_get_vendorlib() {
	debug-print-function $FUNCNAME "$@"

	[[ $# -lt 1 ]] || die "${FUNCNAME}: Too many parameters ($#)"

	# Requires perl 5.14 for /r attribute of s///
	# Just in case somebody out there is stuck in a time warp: upgrade perl first
	perl -M5.014 -MConfig \
		-e'exists $Config{$ARGV[0]} || die qq{No such Config key "$ARGV[0]"};
		   print $Config{$ARGV[0]} =~ s{\A\Q$ARGV[1]\E}{}r;
		   exit 0' -- "installvendorlib" "$EPREFIX" || die "Can't extract installvendorlib from Perl Configuration"
}

# @FUNCTION: perl_domodule
# @USAGE: [-C <target>] [-r] <files>
# @DESCRIPTION:
# Installs files in paths where they can be found in the default
# Perl runtime.
#
# Note: Should only be used in src_install or pkg_preinst
# anywhere else will do the wrong thing or die.
#
# The contents of the <files> list are copied into Perls Vendor library path
# as follows:
# @CODE
#   # install perl/File.pm as Samba::File
#   pushd perl/
#   perl_domodule -C Samba File.pm
#
#   # install perl/ recursively under VENDORLIB/Samba/
#   pushd perl/
#   perl_domodule -C Samba -r .
# @CODE
#
# @CODE
#   options:
#       -C Target/Name
#          The subdirectory relative to the Perl VENDOR_LIB
#          to install into.
#
#          defaults to ""
#       -r
#          Install directories recursively ( see doins )
#          files:
#          list of .pm files to install to VENDORLIB
# @CODE

perl_domodule() {
	local target_prefix=""
	local files=()
	local doins_opts=()

	local recursive="false"
	local target
	local file

	while [[ $# -gt 0 ]] ; do
		case $1 in
			-C|--target-prefix)
				[[ -z "${2}" || "${2:0:1}" == "-" ]] && die "${FUNCNAME}: -C|--target-prefix expects an argument, got \"$2\"!"
				target_prefix="${2}";
				shift 2;;
			-r)
				recursive="true"
				shift;;
			*)
				[[ -z "${1}" || "${1:0:1}" == "-" ]] && die "${FUNCNAME}: Unknown argument \"${1}\"!"
				files+=( "${1}" )
				shift 1;;
		esac
	done

	if [[ "true" == $recursive ]]; then
		doins_opts+=( "-r" )
	fi
	for file in "${files[@]}"; do
		[[ -e "${file}" ]] || die "$FUNCNAME: Argument \"${file}\" is not an existing file"
		[[ "false" == ${recursive} && -d "${file}" ]] && die "$FUNCNAME: Argument \"${file}\" is a directory ( needs -r parameter )"
	done

	target="$(perl_get_vendorlib)"

	# Extend target if target_prefix is set
	[[ -z "${target_prefix}" ]] || target="${target%/}/${target_prefix#/}"

	insinto "/${target#/}"
	doins "${doins_opts[@]}" "${files[@]}"
}

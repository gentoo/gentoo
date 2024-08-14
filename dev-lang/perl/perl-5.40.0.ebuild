# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit alternatives flag-o-matic toolchain-funcs multilib multiprocessing

PATCH_VER=2
CROSS_VER=1.6
PATCH_BASE="perl-5.40.0-patches-${PATCH_VER}"
PATCH_DEV=dilfridge

DIST_AUTHOR=HAARG

# Greatest first, don't include yourself
# Devel point-releases are not ABI-intercompatible, but stable point releases are
# BIN_OLDVERSEN contains only C-ABI-intercompatible versions
PERL_BIN_OLDVERSEN=""

if [[ "${PV##*.}" == "9999" ]]; then
	DIST_VERSION=5.40.0
else
	DIST_VERSION="${PV/_rc/-RC}"
fi
SHORT_PV="${DIST_VERSION%.*}"

# Even numbered major versions are ABI intercompatible
# Odd numbered major versions are not
if [[ $(( ${SHORT_PV#*.} % 2 )) == 1 ]]; then
	SUBSLOT="${DIST_VERSION%-RC*}"
else
	SUBSLOT="${DIST_VERSION%.*}"
fi

# Used only in tar paths
MY_P="perl-${DIST_VERSION}"
# Used in library paths
MY_PV="${DIST_VERSION%-RC*}"

DESCRIPTION="Larry Wall's Practical Extraction and Report Language"

HOMEPAGE="https://www.perl.org/"

SRC_URI="
	mirror://cpan/src/5.0/${MY_P}.tar.xz
	mirror://cpan/authors/id/${DIST_AUTHOR:0:1}/${DIST_AUTHOR:0:2}/${DIST_AUTHOR}/${MY_P}.tar.xz
	https://dev.gentoo.org/~${PATCH_DEV}/distfiles/${PATCH_BASE}.tar.xz
	https://github.com/arsv/perl-cross/releases/download/${CROSS_VER}/perl-cross-${CROSS_VER}.tar.gz
"

S="${WORKDIR}/${MY_P}"

LICENSE="|| ( Artistic GPL-1+ )"

SLOT="0/${SUBSLOT}"

if [[ "${PV##*.}" != "9999" ]] && [[ "${PV/rc//}" == "${PV}" ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

IUSE="berkdb perl_features_debug doc gdbm perl_features_ithreads minimal perl_features_quadmath"

RDEPEND="
	berkdb? ( sys-libs/db:= )
	gdbm? ( >=sys-libs/gdbm-1.8.3:= )
	app-arch/bzip2
	>=sys-libs/zlib-1.2.12
	virtual/libcrypt:=
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"
PDEPEND="
	!minimal? (
		>=app-admin/perl-cleaner-2.31
		>=virtual/perl-CPAN-2.290.0
		>=virtual/perl-Encode-3.120.0
		>=virtual/perl-File-Temp-0.230.400-r2
		>=virtual/perl-Data-Dumper-2.154.0
		>=virtual/perl-Math-BigInt-1.999.842
		virtual/perl-Test-Harness
	)
"

# bug 390719, bug 523624
# virtual/perl-Test-Harness is here for the bundled ExtUtils::MakeMaker

dual_scripts() {
	src_remove_dual      perl-core/Archive-Tar        3.20.10_rc    ptar ptardiff ptargrep
	src_remove_dual      perl-core/CPAN               2.360.0       cpan
	src_remove_dual      perl-core/Digest-SHA         6.40.0        shasum
	src_remove_dual      perl-core/Encode             3.210.0       enc2xs piconv
	src_remove_dual      perl-core/ExtUtils-MakeMaker 7.700.0       instmodsh
	src_remove_dual      perl-core/ExtUtils-ParseXS   3.510.0       xsubpp
	src_remove_dual      perl-core/IO-Compress        2.212.0       zipdetails
	src_remove_dual      perl-core/JSON-PP            4.160.0       json_pp
	src_remove_dual      perl-core/Module-CoreList    5.202.406.90  corelist
	src_remove_dual      perl-core/Pod-Checker        1.770.0       podchecker
	src_remove_dual      perl-core/Pod-Perldoc        3.280.100     perldoc
	src_remove_dual      perl-core/Pod-Usage          2.30.0        pod2usage
	src_remove_dual      perl-core/Test-Harness       3.480.0       prove
	src_remove_dual      perl-core/podlators          5.10.200_rc   pod2man pod2text
	src_remove_dual_man  perl-core/podlators          5.10.200_rc   /usr/share/man/man1/perlpodstyle.1
}

check_rebuild() {
	# Fresh install
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		return 0;
	# Major Upgrade
	# doesn't matter if there's multiple copies, it still needs a rebuild
	# if the string is anything other than "5.CURRENTMAJOR"
	elif [[ "${REPLACING_VERSIONS%.*}" != "${PV%.*}" ]]; then
		echo ""
		ewarn "UPDATE THE PERL MODULES:"
		ewarn "After updating dev-lang/perl the installed Perl modules"
		ewarn "have to be re-installed. In most cases, this is done automatically"
		ewarn "by the package manager, but subsequent steps are still recommended"
		ewarn "to ensure system consistency."
		ewarn
		ewarn "You should start with a depclean to remove any unused perl dependencies"
		ewarn "that may confuse portage in future. Regular depcleans are also encouraged"
		ewarn "as part of your regular update cycle, as that will keep perl upgrades working."
		ewarn "Recommended: emerge --depclean -va"
		ewarn
		ewarn "You should then call perl-cleaner to clean up any old files and trigger any"
		ewarn "remaining rebuilds portage may have missed."
		ewarn "Use: perl-cleaner --all"
		return 0;

	# Reinstall w/ USE Change
	elif
		 (   use perl_features_ithreads && ( has_version '<dev-lang/perl-5.38.2-r3[-ithreads]' || has_version '>=dev-lang/perl-5.38.2-r3[-perl_features_ithreads]' ) ) || \
		 ( ! use perl_features_ithreads && ( has_version '<dev-lang/perl-5.38.2-r3[ithreads]'  || has_version '>=dev-lang/perl-5.38.2-r3[perl_features_ithreads]'  ) ) || \
		 (   use perl_features_quadmath && ( has_version '<dev-lang/perl-5.38.2-r3[-quadmath]' || has_version '>=dev-lang/perl-5.38.2-r3[-perl_features_quadmath]' ) ) || \
		 ( ! use perl_features_quadmath && ( has_version '<dev-lang/perl-5.38.2-r3[quadmath]'  || has_version '>=dev-lang/perl-5.38.2-r3[perl_features_quadmath]'  ) ) || \
		 (   use perl_features_debug    && ( has_version '<dev-lang/perl-5.38.2-r3[-debug]'    || has_version '>=dev-lang/perl-5.38.2-r3[-perl_features_debug]'    ) ) || \
		 ( ! use perl_features_debug    && ( has_version '<dev-lang/perl-5.38.2-r3[debug]'     || has_version '>=dev-lang/perl-5.38.2-r3[perl_features_debug]'     ) ) ; then
		echo ""
		ewarn "TOGGLED PERL FEATURES WARNING:"
		ewarn "You changed one of the PERL_FEATURES flags ithreads, quadmath, or debug."
		ewarn "You must rebuild all perl-modules installed. Mostly this should be done automatically"
		ewarn "via the flag changes of the packages. If the rebuild fails, use perl-cleaner."
		ewarn "Use: perl-cleaner --modules ; perl-cleaner --force --libperl"
		ewarn
		ewarn "NOTE: Previous to perl-5.38.2-r3, these flags were useflags for dev-lang/perl."
		ewarn "If you just upgraded and do not intend to change anything, carry the same settings over"
		ewarn "into a global PERL_FEATURES variable set in make.conf. E.g., "
		ewarn "dev-lang/perl[ithreads,quadmath] becomes PERL_FEATURES=\"ithreads quadmath\""
	fi
}

pkg_pretend() {
	if \
		 (   use perl_features_ithreads && has_version '<dev-lang/perl-5.38.2-r3[-ithreads]' ) || \
		 ( ! use perl_features_ithreads && has_version '<dev-lang/perl-5.38.2-r3[ithreads]'  ) || \
		 (   use perl_features_quadmath && has_version '<dev-lang/perl-5.38.2-r3[-quadmath]' ) || \
		 ( ! use perl_features_quadmath && has_version '<dev-lang/perl-5.38.2-r3[quadmath]'  ) || \
		 (   use perl_features_debug    && has_version '<dev-lang/perl-5.38.2-r3[-debug]'    ) || \
		 ( ! use perl_features_debug    && has_version '<dev-lang/perl-5.38.2-r3[debug]'     ) ;  \
	then
		echo ""
		ewarn "As of dev-lang/perl-5.38.2-r3, the useflags debug, ithreads, quadmath move into"
		ewarn "a use-expand variable PERL_FEATURES, which should be set globally in make.conf."
		ewarn "It appears that you have not set this variable properly yet."
		ewarn ""
		ewarn "Giving you a chance to abort and read the corresponding news item now..."
		for n in 10 9 8 7 6 5 4 3 2 1 ; do
			echo -n "${n} "
			sleep 2
		done;
		echo "continuing."
	fi
}

pkg_setup() {
	case ${CHOST} in
		*-darwin*)    osname="darwin" ;;
		*-solaris*)   osname="solaris" ;;
		*)            osname="linux" ;;
	esac

	myarch="${CHOST%%-*}-${osname}"
	if use perl_features_debug ; then
		myarch+="-debug"
	fi
	if use perl_features_quadmath ; then
		myarch+="-quadmath"
	fi
	if use perl_features_ithreads ; then
		mythreading="-multi"
		myarch+="-thread"
	fi

	PRIV_BASE="/usr/$(get_libdir)/perl5"
	SITE_BASE="/usr/local/$(get_libdir)/perl5"
	VENDOR_BASE="/usr/$(get_libdir)/perl5/vendor_perl"

	LIBPERL="libperl$(get_libname ${MY_PV} )"

	PRIV_LIB="${PRIV_BASE}/${SUBSLOT}"
	ARCH_LIB="${PRIV_BASE}/${SUBSLOT}/${myarch}${mythreading}"
	SITE_LIB="${SITE_BASE}/${SUBSLOT}"
	SITE_ARCH="${SITE_BASE}/${SUBSLOT}/${myarch}${mythreading}"
	VENDOR_LIB="${VENDOR_BASE}/${SUBSLOT}"
	VENDOR_ARCH="${VENDOR_BASE}/${SUBSLOT}/${myarch}${mythreading}"

	dual_scripts
}

src_remove_dual_file() {
	local i pkg ver
	pkg="$1"
	ver="$2"
	shift 2
	case "${EBUILD_PHASE:-none}" in
		postinst|postrm)
			for i in "$@" ; do
				alternatives_auto_makesym "${i}" "${i}-[0-9]*"
			done
			;;
		setup)
			for i in "$@" ; do
				if [[ -f ${EROOT}${i} && ! -h ${EROOT}${i} ]] ; then
					has_version ${pkg} && ewarn "You must reinstall ${pkg} !"
					break
				fi
			done
			;;
		install)
			for i in "$@" ; do
				if ! [[ -f "${ED}"${i} ]] ; then
					ewarn "${i} does not exist!"
					continue
				fi
				mv "${ED}"${i}{,-${ver}-${P}} || die
			done
			;;
	esac
}

src_remove_dual_man() {
	local i pkg ver ff
	pkg="$1"
	ver="$2"
	shift 2
	case "${EBUILD_PHASE:-none}" in
		postinst|postrm)
			for i in "$@" ; do
				ff=`echo "${EROOT}${i%.[0-9]}-${ver}-${P}${i#${i%.[0-9]}}"*`
				ff=${ff##*${i#${i%.[0-9]}}}
				alternatives_auto_makesym "${i}${ff}" "${i%.[0-9]}-[0-9]*"
			done
			;;
		install)
			for i in "$@" ; do
				if ! [[ -f "${ED}"${i} ]] ; then
					ewarn "${i} does not exist!"
					continue
				fi
				mv "${ED}"${i} "${ED}"${i%.[0-9]}-${ver}-${P}${i#${i%.[0-9]}} || die
			done
			;;
	esac
}

src_remove_dual() {
	local i pkg ver
	pkg="$1"
	ver="$2"
	shift 2
	for i in "$@" ; do
		src_remove_dual_file  "${pkg}" "${ver}" "/usr/bin/${i}"
		src_remove_dual_man   "${pkg}" "${ver}" "/usr/share/man/man1/${i}.1"
	done
}

src_prepare_perlcross() {
	cp -a ../perl-cross-${CROSS_VER}/* . || die

	# bug 794463, needs further analysis what is exactly wrong here
	eapply "${FILESDIR}/perl-5.34.0-crossfit.patch"

	# bug 604072
	MAKEOPTS+=" -j1"
	export MAKEOPTS
}

src_prepare_dynamic() {
	ln -s ${LIBPERL} libperl$(get_libname ${SHORT_PV}) || die
	ln -s ${LIBPERL} libperl$(get_libname ) || die
}

# Copy a patch into the patch series
# add_patch SRC_PATH DEST_NAME ['description'] ['bug'] ['bug']
# - description is optional, but recommended
# - all arguments after descriptions are bug URLs
add_patch() {
	local patchdir="${WORKDIR}/patches"
	local infodir="${WORKDIR}/patch-info"
	local src_name dest_name desc
	src_name="$1"
	dest_name="$2"
	desc="$3"
	shift; shift; shift;
	einfo "Adding ${dest_name} to patch bundle"
	cp "${src_name}" "${patchdir}/${dest_name}" || die "Couldn't copy ${src_name} to ${dest_name}"
	if [[ -n "${desc}" ]]; then
		printf "%s" "${desc}" > "${infodir}/${dest_name}.desc" || die "Couldn't write ${dest_name}.desc"
	fi
	if [[ $# -gt 0 ]]; then
		# Note: when $@ is more than one element, this emits a
		# line for each element
		printf "%s\n" "$@" > "${infodir}/${dest_name}.bugs" || die "Couldn't write ${dest_name}.bugs"
	fi
}

# Remove a patch using a glob expr
# eg:
#	 rm_patch *-darwin-Use-CC*
#
rm_patch() {
	local patchdir="${WORKDIR}/patches"
	local expr="$1"
	local patch="$( cd "${patchdir}"; echo $expr )"
	einfo "Removing $patch ($expr) from patch bundle"
	if [[ -e "${patchdir}/${patch}" ]]; then
		rm -f "${patchdir}/${patch}" || die "Can't remove ${patch} ( $expr )"
	else
		ewarn "No ${expr} found in ${patchdir} to remove"
	fi
}

# Yes, this is a reasonable amount of code for something seemingly simple
# but this is far easier to debug when things go wrong, and things went wrong
# multiple times while I was getting the exact number of slashes right, which
# requires circumnavigating both bash and sed escape mechanisms.
c_escape_string() {
	local slash dquote
	slash='\'
	dquote='"'
	re_slash="${slash}${slash}"
	re_dquote="${slash}${dquote}"

	# Convert \ to \\,
	#         " to \"
	echo "$1" |\
		sed "s|${re_slash}|${re_slash}${re_slash}|g" |\
		sed "s|${re_dquote}|${re_slash}${re_dquote}|g"
}
c_escape_file() {
	c_escape_string "$(cat "$1")"
}

apply_patchdir() {
	local patchdir="${WORKDIR}/patches"
	local infodir="${WORKDIR}/patch-info"
	local patchoutput="patchlevel-gentoo.h"

	# Inject Patch-Level info into description for patchlevel.h patch
	# to show in -V
	local patch_expr="*List-packaged-patches*"
	local patch="$( cd "${patchdir}"; echo $patch_expr )";
	einfo "Injecting patch-level info into ${patch}.desc ( $patch_expr )"

	if [[ -e "${patchdir}/${patch}" ]]; then
		printf "List packaged patches for %s(%s) in patchlevel.h" "${PF}" "${PATCH_BASE}"\
			>"${infodir}/${patch}.desc" || die "Can't rewrite ${patch}.desc"
	else
		eerror "No $patch_expr found in ${patchdir}"
	fi

	# Compute patch list to apply
	# different name other than PATCHES to stop default
	# reapplying it
	# Single depth is currently only supported, as artifacts can reside
	# from the old layout being multiple-directories, as well as it grossly
	# simplifying the patchlevel_gentoo.h generation.
	local PERL_PATCHES=($(
		find "${patchdir}" -maxdepth 1 -mindepth 1 -type f -printf "%f\n" |\
			grep -E '[.](diff|patch)$' |\
			sort -n
	))

	for patch in "${PERL_PATCHES[@]}"; do
		eapply "${WORKDIR}"/patches/${patch}
	done

	einfo "Generating $patchoutput"

	# This code creates a header file, each iteration
	# creates one-or-more-lines for each entry found in PERL_PATCHES
	# and STDOUT is redirected to the .h file
	for patch in "${PERL_PATCHES[@]}"; do
		local desc_f="${infodir}/${patch}.desc"
		local bugs_f="${infodir}/${patch}.bugs"

		printf ',"%s"\n' "${patch}"
		if [[ ! -e "${desc_f}" ]]; then
			ewarn "No description provided for ${patch} (expected: ${desc_f} )"
		else
			local desc="$(c_escape_file "${desc_f}")"
			printf ',"- %s"\n' "${desc}"
		fi
		if [[ -e "${bugs_f}" ]]; then
			while read -d $'\n' -r line; do
				local esc_line="$(c_escape_string "${line}")"
				printf ',"- Bug: %s"\n' "${esc_line}"
			done <"${bugs_f}"
		fi
	done > "${S}/${patchoutput}"
	printf "%s\n" "${patchoutput}" >> "${S}/MANIFEST"

}

src_prepare() {

	local patchdir="${WORKDIR}/patches"

	# mv -v "${WORKDIR}/perl-patchset-${PATCH_BASE}/patches" "${WORKDIR}/patches" || die
	# mv -v "${WORKDIR}/perl-patchset-${PATCH_BASE}/patch-info" "${WORKDIR}/patch-info" || die

	# Prepare Patch dir with additional patches / remove unwanted patches
	# Inject bug/desc entries for perl -V
	# Old example:
	# add_patch "${FILESDIR}/${PN}-5.26.2-hppa.patch" "100-5.26.2-hppa.patch"\
	#		"Fix broken miniperl on hppa"\
	#		"https://bugs.debian.org/869122" "https://bugs.gentoo.org/634162"

	if [[ ${CHOST} == *-solaris* ]] ; then
		# do NOT mess with nsl, on Solaris this is always necessary,
		# when -lsocket is used e.g. to get h_errno
		rm_patch "*-nsl-and-cl*"
	fi

	apply_patchdir

	tc-is-cross-compiler && src_prepare_perlcross

	tc-is-static-only || src_prepare_dynamic

	if use gdbm; then
		sed -i "s:INC => .*:INC => \"-I${EROOT}/usr/include/gdbm\":g" \
			ext/NDBM_File/Makefile.PL || die
	fi

	# Use errno.h from prefix rather than from host system, bug #645804
	if use prefix && [[ -e "${EPREFIX}"/usr/include/errno.h ]] ; then
		sed -i "/my..sysroot/s:'':'${EPREFIX}':" ext/Errno/Errno_pm.PL || die
	fi

	if [[ ${CHOST} == *-solaris* ]] ; then
		# set a soname, fix linking against just built libperl
		sed -i -e 's/netbsd\*/netbsd*|solaris*/' Makefile.SH || die
	fi

	if [[ ${CHOST} == *-darwin* ]] ; then
		# fix install_name (soname) not to reference $D
		sed -i -e '/install_name `pwd/s/`pwd`/\\$(shrpdir)/' Makefile.SH || die

		# fix environ linkage absence (only a real issue on Darwin9)
		if [[ ${CHOST##*-darwin} -le 9 ]] ; then
			sed -i -e '/^PLDLFLAGS =/s/=/= -include crt_externs.h -Denviron="(*_NSGetEnviron())"/' \
				Makefile.SH || die
		fi
	fi

	default
}

myconf() {
	# the myconf array is declared in src_configure
	myconf=( "${myconf[@]}" "$@" )
}

# Outputs a list of versions which have been seen in any of the
# primary perl @INC prefix paths, such as:
#  /usr/lib64/perl5/<NUMBER>
#  /usr/local/lib64/perl5/<NUMBER>
#  /usr/lib64/perl5/vendor_perl/<NUMBER>
#
# All values of NUMBER must be like "5.x.y" or like "5.x"
#
find_candidate_inc_versions() {
	local regex='.*/5[.][0-9]+\([.][0-9]+\|\)$'
	local dirs=(
		"${EROOT}${PRIV_BASE}"
		"${EROOT}${SITE_BASE}"
		"${EROOT}${VENDOR_BASE}"
	)
	for dir in "${dirs[@]}"; do
		if [[ ! -e "${dir}" ]]; then
			continue
		fi
		# Without access to readdir() on these dirs, find will not be able
		# to reveal any @INC directories inside them, and will subsequently prune
		# them from the built perl's @INC support, breaking our compatiblity options
		# entirely.
		if [[ ! -r "${dir}" || ! -x "${dir}" ]]; then
			eerror "Bad permissions on ${dir}, this will probably break things"
			eerror "Ensure ${dir} is +rx for at least uid=$EUID"
			eerror "Recommended permission is +rx for all"
			eerror "> chmod o+rx ${dir}"
		fi
	done
	einfo "Scanning for old @INC dirs matching '$regex' in: ${dirs[*]}"
	find "${dirs[@]}" -maxdepth 1 -mindepth 1 -type d -regex "${regex}" -printf "%f "  2>/dev/null
}

# Sort versions passed versiony-ly, remove self-version if present
# dedup. Takes each version as an argument
sanitize_inc_versions() {
	local vexclude="${SUBSLOT}"
	einfo "Normalizing/Sorting candidate list: $*"
	einfo " to remove '${vexclude}'"
	# Note, general numeric sort has to be used
	# for the last component, or unique will convert
	#  5.30.0 + 5.30 into just 5.30
	printf "%s\n" "$@" |\
		grep -vxF "${vexclude}" |\
		sort -u -nr -t'.' -k1,1rn -k2,2rn -k3,3rg
}

versions_to_inclist() {
	local oldv="${DIST_VERSION%-RC} ${PERL_BIN_OLDVERSEN}"

	for v;	do
			has "${v}" ${oldv} && echo -n "${v}/${myarch}${mythreading}/ ";
			echo -n "${v}/ ";
	done
}

versions_to_gentoolibdirs() {
	local oldv="${DIST_VERSION%-RC} ${PERL_BIN_OLDVERSEN}"
	local root
	local v
	for v;	do
		for root in "${PRIV_BASE}" "${VENDOR_BASE}" "${SITE_BASE}"; do
			local fullpath="${EROOT}${root}/${v}"
			if [[ -e "${fullpath}" ]]; then
				has "${v}" ${oldv} && printf "%s:" "${fullpath}/${myarch}${mythreading}";
				printf "%s:" "${fullpath}"
			fi
		done
	done
}

src_configure() {
	declare -a myconf

	export LC_ALL="C"
	[[ ${COLUMNS:-1} -ge 1 ]] || unset COLUMNS # bug #394091

	# Perl has problems compiling with -Os in your flags with glibc
	replace-flags "-Os" "-O2"

	# xlocale.h is going away in glibc-2.26, so it's counterproductive
	# if we use it and include it in CORE/perl.h ... Perl builds just
	# fine with glibc and locale.h only.
	# However, the darwin prefix people have no locale.h ...
	use elibc_glibc && myconf -Ui_xlocale

	# Perl relies on -fwrapv semantics
	filter-flags -ftrapv

	# This flag makes compiling crash in interesting ways
	filter-flags "-malign-double"

	# On musl we dont want to use largefile *64 types, since 1) normal
	# types are 64bit / largefile anyway and 2) the *64 types are going
	# away in 1.2.4... bug #911233
	use elibc_musl && myconf -Ud_off64_t

	use sparc && myconf -Ud_longdbl

	# This urgently needs debugging - on m68k, miniperl crashes during
	# build otherwise..
	use m68k && append-ldflags -Wl,-z,norelro

	export BUILD_BZIP2=0
	export BZIP2_INCLUDE=${EROOT}/usr/include
	export BZIP2_LIB=${EROOT}/usr/$(get_libdir)

	export BUILD_ZLIB=False
	export ZLIB_INCLUDE=${EROOT}/usr/include
	export ZLIB_LIB=${EROOT}/usr/$(get_libdir)

	# allow either gdbm to provide ndbm (in <gdbm/ndbm.h>) or db1
	myndbm='U'
	mygdbm='U'
	mydb='U'
	if use gdbm ; then
		mygdbm='D'
		if use berkdb ; then
			myndbm='D'
		fi
	fi
	if use berkdb ; then
		mydb='D'
		has_version '=sys-libs/db-1*' && myndbm='D'
	fi

	myconf "-${myndbm}i_ndbm" "-${mygdbm}i_gdbm" "-${mydb}i_db"

	if use alpha && [[ "$(tc-getCC)" = "ccc" ]] ; then
		ewarn "Perl will not be built with berkdb support, use gcc if you need it..."
		myconf -Ui_db -Ui_ndbm
	fi

	use perl_features_ithreads && myconf -Dusethreads

	use perl_features_quadmath && myconf -Dusequadmath

	if use perl_features_debug ; then
		append-cflags "-g"
		myconf -DDEBUGGING
	elif [[ ${CFLAGS} == *-g* ]] ; then
		myconf -DDEBUGGING=-g
	else
		myconf -DDEBUGGING=none
	fi

	# modifying 'optimize' prevents cross configure script from appending required flags
	if tc-is-cross-compiler; then
		append-cflags "-fwrapv"

		# Needed for the CHOST build too (bug #932385)
		export CFLAGS="${CFLAGS} -D_GNU_SOURCE"

		# bug #913171
		export HOSTCFLAGS="${CFLAGS_FOR_BUILD} -D_GNU_SOURCE"
	fi

	# bug #877659, bug #821577
	append-cflags -fno-strict-aliasing

	# Autodiscover all old version directories, some of them will even be newer
	# if you downgrade
	if [[ -z ${PERL_OLDVERSEN} ]]; then
		PERL_OLDVERSEN="$( find_candidate_inc_versions )"
	fi

	# Fixup versions, removing self match, fixing order and dupes
	PERL_OLDVERSEN="$( sanitize_inc_versions ${PERL_OLDVERSEN} )"

	# Experts who want a "Pure" install can set PERL_OLDVERSEN to an empty string
	if [[ -n "${PERL_OLDVERSEN// }" ]]; then
		local inclist="$( versions_to_inclist ${PERL_OLDVERSEN} )"
		einfo "This version of perl may partially support modules previously"
		einfo "installed in any of the following paths:"
		for incpath in ${inclist}; do
			[[ -e "${EROOT}${VENDOR_BASE}/${incpath}" ]] && einfo " ${EROOT}${VENDOR_BASE}/${incpath}"
			[[ -e "${EROOT}${PRIV_BASE}/${incpath}"   ]] && einfo " ${EROOT}${PRIV_BASE}/${incpath}"
			[[ -e "${EROOT}${SITE_BASE}/${incpath}"   ]] && einfo " ${EROOT}${SITE_BASE}/${incpath}"
		done
		einfo "This is a temporary measure and you should aim to cleanup these paths"
		einfo "via world updates and perl-cleaner"
		# myconf -Dinc_version_list="${inclist}"
		myconf -Dgentoolibdirs="$( versions_to_gentoolibdirs ${PERL_OLDVERSEN} )"
	fi

	[[ ${ELIBC} == "FreeBSD" ]] && myconf "-Dlibc=/usr/$(get_libdir)/libc.a"

	# Make sure we can do the final link #523730, need to set deployment
	# target to override hardcoded 10.3 which breaks on modern OSX
	[[ ${CHOST} == *-darwin* ]] && \
		myconf "-Dld=env MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET} $(tc-getCC)"

	# Older macOS with non-Apple GCC chokes on inline in system headers
	# using c89 mode as injected by cflags.SH, in addition, we override
	# cflags, so we loose PERL_DARWIN which enables compat code that
	# apparently on more recent macOS releases is no longer necessary
	[[ ${CHOST} == *-darwin* && ${CHOST##*darwin} -le 9 ]] && tc-is-gcc && \
		append-cflags -Dinline=__inline__ -DPERL_DARWIN

	# Prefix: the host system needs not to follow Gentoo multilib stuff, and in
	# Prefix itself we don't do multilib either, so make sure perl can find
	# something compatible.
	if use prefix ; then
		# Set a hook to check for each detected library whether it actually works.
		export libscheck="
			( echo 'int main(){}' > '${T}'/conftest.c &&
				$(tc-getCC) -o '${T}'/conftest '${T}'/conftest.c -l\$thislib >/dev/null 2>/dev/null
			) || xxx=/dev/null"

		# Use all host paths that might contain useful stuff, the hook above will filter out bad choices.
		local paths="/lib/*-linux-gnu /usr/lib/*-linux-gnu /lib64 /lib/64 /usr/lib64 /usr/lib/64 /lib32 /usr/lib32 /lib /usr/lib"
		myconf "-Dlibpth=${EPREFIX}/$(get_libdir) ${EPREFIX}/usr/$(get_libdir) ${paths}"
	elif [[ $(get_libdir) != "lib" ]] ; then
		# We need to use " and not ', as the written config.sh use ' ...
		myconf "-Dlibpth=/usr/local/$(get_libdir) /$(get_libdir) /usr/$(get_libdir)"
	fi

	# don't try building ODBM, bug #354453
	disabled_extensions="ODBM_File"

	if ! use gdbm ; then
		# workaround for bug #157774: don't try building GDBM related stuff with USE="-gdbm"
		disabled_extensions="${disabled_extensions} GDBM_File NDBM_File"
	fi

	myconf -Dnoextensions="${disabled_extensions}"

	[[ "${PV##*.}" == "9999" ]] && myconf -Dusedevel -Uversiononly

	[[ -n "${EXTRA_ECONF}" ]] && ewarn During Perl build, EXTRA_ECONF=${EXTRA_ECONF}
	# allow fiddling via EXTRA_ECONF, bug 558070
	eval "local -a EXTRA_ECONF=(${EXTRA_ECONF})"

	myconf \
		-Duseshrplib \
		-Darchname="${myarch}" \
		-Dar="$(tc-getAR)" \
		-Dcc="$(tc-getCC)" \
		-Dcpp="$(tc-getCPP)" \
		-Dld="$(tc-getCC)" \
		-Dnm="$(tc-getNM)" \
		-Dranlib="$(tc-getRANLIB)" \
		-Accflags="${CFLAGS} -DNO_PERL_RAND_SEED" \
		-Doptimize="${CFLAGS}" \
		-Dldflags="${LDFLAGS}" \
		-Dprefix="${EPREFIX}"'/usr' \
		-Dsiteprefix="${EPREFIX}"'/usr/local' \
		-Dvendorprefix="${EPREFIX}"'/usr' \
		-Dscriptdir="${EPREFIX}"'/usr/bin' \
		-Dprivlib="${EPREFIX}${PRIV_LIB}" \
		-Darchlib="${EPREFIX}${ARCH_LIB}" \
		-Dsitelib="${EPREFIX}${SITE_LIB}" \
		-Dsitearch="${EPREFIX}${SITE_ARCH}" \
		-Dvendorlib="${EPREFIX}${VENDOR_LIB}" \
		-Dvendorarch="${EPREFIX}${VENDOR_ARCH}" \
		-Dman1dir="${EPREFIX}"/usr/share/man/man1 \
		-Dman3dir="${EPREFIX}"/usr/share/man/man3 \
		-Dsiteman1dir="${EPREFIX}"/usr/local/man/man1 \
		-Dsiteman3dir="${EPREFIX}"/usr/local/man/man3 \
		-Dvendorman1dir="${EPREFIX}"/usr/share/man/man1 \
		-Dvendorman3dir="${EPREFIX}"/usr/share/man/man3 \
		-Dman1ext='1' \
		-Dman3ext='3pm' \
		-Dlibperl="${LIBPERL}" \
		-Dlocincpth="${EPREFIX}"'/usr/include ' \
		-Dglibpth="${EPREFIX}/$(get_libdir) ${EPREFIX}/usr/$(get_libdir)"' ' \
		-Duselargefiles \
		-Dd_semctl_semun \
		-Dcf_by='Gentoo' \
		-Dmyhostname='localhost' \
		-Dperladmin='root@localhost' \
		-Ud_csh \
		-Dsh="${EPREFIX}"/bin/sh \
		-Dtargetsh="${EPREFIX}"/bin/sh \
		-Uusenm \
		"${EXTRA_ECONF[@]}"

	if tc-is-cross-compiler; then
		./configure \
			--target="${CHOST}" \
			--build="${CBUILD}" \
			-Dinstallprefix='' \
			-Dinstallusrbinperl='undef' \
			-Dusevendorprefix='define' \
			"${myconf[@]}" \
			|| die "Unable to configure"
	else
		sh Configure \
			-des \
			-Dinstallprefix="${EPREFIX}"'/usr' \
			-Dinstallusrbinperl='n' \
			"${myconf[@]}" \
			|| die "Unable to configure"
	fi
}

src_test() {
	export NO_GENTOO_NETWORK_TESTS=1;
	export GENTOO_ASSUME_SANDBOXED="${GENTOO_ASSUME_SANDBOXED:-1}"
	export GENTOO_NO_PORTING_TESTS="${GENTOO_NO_PORTING_TESTS:-1}"
	if [[ ${EUID} == 0 ]] ; then
		ewarn "Test fails with a sandbox error (#328793) if run as root. Skipping tests..."
		return 0
	fi
	TEST_JOBS="$(makeopts_jobs)" make test_harness || die "test failed"
}

src_install() {
	local i
	local coredir="${ARCH_LIB}/CORE"

	emake DESTDIR="${D}" install

	rm -f "${ED}/usr/bin/perl${MY_PV}"
	ln -s perl "${ED}"/usr/bin/perl${MY_PV} || die

	if ! tc-is-static-only ; then
		dolib.so "${ED}"${coredir}/${LIBPERL}
		rm -f "${ED}"${coredir}/${LIBPERL}
		ln -sf ${LIBPERL} "${ED}"/usr/$(get_libdir)/libperl$(get_libname ${SHORT_PV}) || die
		ln -sf ${LIBPERL} "${ED}"/usr/$(get_libdir)/libperl$(get_libname) || die

		ln -sf ../../../../${LIBPERL} "${ED}"${coredir}/${LIBPERL} || die
		ln -sf ../../../../${LIBPERL} "${ED}"${coredir}/libperl$(get_libname ${SHORT_PV}) || die
		ln -sf ../../../../${LIBPERL} "${ED}"${coredir}/libperl$(get_libname) || die
	fi

	rm -rf "${ED}"/usr/share/man/man3 || die "Unable to remove module man pages"

	# This removes ${D} from Config.pm
	for i in $(find "${D}" -iname "Config.pm" ) ; do
		einfo "Removing ${D} from ${i}..."
		sed -i -e "s:${D}::" "${i}" || die "Sed failed"
	done

	dodoc Changes* README AUTHORS

	if use doc ; then
		# HTML Documentation
		# We expect errors, warnings, and such with the following.

		dodir /usr/share/doc/${PF}/html
		LD_LIBRARY_PATH=. ./perl installhtml \
			--podroot='.' \
			--podpath='lib:ext:pod:vms' \
			--recurse \
			--htmldir="${ED}/usr/share/doc/${PF}/html"
	fi

	[[ -d ${ED}/usr/local ]] && rm -r "${ED}"/usr/local

	dual_scripts
}

pkg_preinst() {
	check_rebuild
}

pkg_postinst() {
	dual_scripts

	if [[ -z "${ROOT}" ]] ; then
		local INC DIR file
		INC=$(perl -e 'for $line (@INC) { next if $line eq "."; next if $line =~ m/'${SHORT_PV}'|etc|local|perl$/; print "$line\n" }')
		einfo "Removing old .ph files"
		for DIR in ${INC} ; do
			if [[ -d "${DIR}" ]] ; then
				for file in $(find "${DIR}" -name "*.ph" -type f ) ; do
					rm -f "${file}"
					einfo "<< ${file}"
				done
			fi
		done
		# Silently remove the now empty dirs
		for DIR in ${INC} ; do
			if [[ -d "${DIR}" ]] ; then
				find "${DIR}" -depth -type d -print0 | xargs -0 -r rmdir &> /dev/null
			fi
		done

	fi
}

pkg_postrm() {
	dual_scripts
}

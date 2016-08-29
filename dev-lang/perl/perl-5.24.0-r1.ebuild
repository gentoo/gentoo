# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils alternatives flag-o-matic toolchain-funcs multilib multiprocessing

PATCH_VER=2

PERL_OLDVERSEN=""
MODULE_AUTHOR=RJBS

SHORT_PV="${PV%.*}"
MY_P="perl-${PV/_rc/-RC}"
MY_PV="${PV%_rc*}"

DESCRIPTION="Larry Wall's Practical Extraction and Report Language"

SRC_URI="
	mirror://cpan/src/5.0/${MY_P}.tar.bz2
	mirror://cpan/authors/id/${MODULE_AUTHOR:0:1}/${MODULE_AUTHOR:0:2}/${MODULE_AUTHOR}/${MY_P}.tar.bz2
	mirror://gentoo/${MY_P}-patches-${PATCH_VER}.tar.xz
	https://dev.gentoo.org/~dilfridge/distfiles/${MY_P}-patches-${PATCH_VER}.tar.xz
"
HOMEPAGE="http://www.perl.org/"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0/${SHORT_PV}"
KEYWORDS="~alpha ~amd64 ~amd64-fbsd ~amd64-linux ~arm ~arm64 ~hppa ~hppa-hpux ~ia64 ~ia64-hpux ~ia64-linux ~m68k ~m68k-mint ~mips ~ppc ~ppc64 ~ppc-aix ~ppc-macos ~s390 ~sh ~sparc ~sparc64-solaris ~sparc-solaris ~x64-freebsd ~x64-macos ~x64-solaris ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~x86-linux ~x86-macos ~x86-solaris"
IUSE="berkdb debug doc gdbm ithreads"

RDEPEND="
	berkdb? ( sys-libs/db:* )
	gdbm? ( >=sys-libs/gdbm-1.8.3 )
	app-arch/bzip2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	!prefix? ( elibc_FreeBSD? ( sys-freebsd/freebsd-mk-defs ) )
"
PDEPEND="
	>=app-admin/perl-cleaner-2.5
	>=virtual/perl-File-Temp-0.230.400-r2
	>=virtual/perl-Data-Dumper-2.154.0
	virtual/perl-Test-Harness
"
# bug 390719, bug 523624
# virtual/perl-Test-Harness is here for the bundled ExtUtils::MakeMaker

S="${WORKDIR}/${MY_P}"

dual_scripts() {
	src_remove_dual      perl-core/Archive-Tar        2.40.0        ptar ptardiff ptargrep
	src_remove_dual      perl-core/Digest-SHA         5.950.0       shasum
	src_remove_dual      perl-core/CPAN               2.110.0       cpan
	src_remove_dual      perl-core/Encode             2.800.0       enc2xs piconv
	src_remove_dual      perl-core/ExtUtils-MakeMaker 7.100.100_rc  instmodsh
	src_remove_dual      perl-core/ExtUtils-ParseXS   3.310.0       xsubpp
	src_remove_dual      perl-core/IO-Compress        2.69.0        zipdetails
	src_remove_dual      perl-core/JSON-PP            2.273.0       json_pp
	src_remove_dual      perl-core/Module-CoreList    5.201.605.60  corelist
	src_remove_dual      perl-core/Pod-Parser         1.630.0       pod2usage podchecker podselect
	src_remove_dual      perl-core/Pod-Perldoc        3.250.200_rc  perldoc
	src_remove_dual      perl-core/Test-Harness       3.360.0       prove
	src_remove_dual      perl-core/podlators          4.70.0        pod2man pod2text
	src_remove_dual_man  perl-core/podlators          4.70.0        /usr/share/man/man1/perlpodstyle.1
}

check_rebuild() {
	if has_version "<dev-lang/perl-${SHORT_PV}" ; then
		echo ""
		ewarn "UPDATE THE PERL MODULES:"
		ewarn "After updating dev-lang/perl the installed Perl modules"
		ewarn "have to be re-installed. In most cases, this is done automatically"
		ewarn "by the package manager, but you should still call perl-cleaner to"
		ewarn "make sure your system is consistent."
		ewarn "Use: perl-cleaner --all"
	elif has_version dev-lang/perl ; then
		if (   use ithreads && ! has_version dev-lang/perl[ithreads] ) || \
		   ( ! use ithreads &&   has_version dev-lang/perl[ithreads] ) || \
		   (   use debug    && ! has_version dev-lang/perl[debug]    ) || \
		   ( ! use debug    &&   has_version dev-lang/perl[debug]    ) ; then
			echo ""
			ewarn "TOGGLED USE-FLAGS WARNING:"
			ewarn "You changed one of the use-flags ithreads or debug."
			ewarn "You must rebuild all perl-modules installed."
			ewarn "Use: perl-cleaner --modules ; perl-cleaner --force --libperl"
		fi
	fi
}

pkg_setup() {
	case ${CHOST} in
		*-freebsd*)   osname="freebsd" ;;
		*-dragonfly*) osname="dragonfly" ;;
		*-netbsd*)    osname="netbsd" ;;
		*-openbsd*)   osname="openbsd" ;;
		*-darwin*)    osname="darwin" ;;
		*-interix*)   osname="interix" ;;
		*-aix*)       osname="aix" ;;
		*-cygwin*)    osname="cygwin" ;;
		*)            osname="linux" ;;
	esac

	myarch="${CHOST%%-*}-${osname}"
	if use debug ; then
		myarch+="-debug"
	fi
	if use ithreads ; then
		mythreading="-multi"
		myarch+="-thread"
	fi

	LIBPERL="libperl$(get_libname ${MY_PV} )"
	PRIV_LIB="/usr/$(get_libdir)/perl5/${MY_PV}"
	ARCH_LIB="/usr/$(get_libdir)/perl5/${MY_PV}/${myarch}${mythreading}"
	SITE_LIB="/usr/local/$(get_libdir)/perl5/${MY_PV}"
	SITE_ARCH="/usr/local/$(get_libdir)/perl5/${MY_PV}/${myarch}${mythreading}"
	VENDOR_LIB="/usr/$(get_libdir)/perl5/vendor_perl/${MY_PV}"
	VENDOR_ARCH="/usr/$(get_libdir)/perl5/vendor_perl/${MY_PV}/${myarch}${mythreading}"

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

src_prepare_update_patchlevel_h() {
	# Copied and modified from debian:
	# Copyright 2011 Niko Tyni
	# This program is free software; you can redistribute it and/or modify
	# it under the same terms as Perl itself.
	local patchdir="${WORKDIR}/patches"
	local prefix
	local patchoutput="patchlevel-gentoo.h"

	[[ -f ${patchdir}/series ]] || return 0

while read patch
do
	patchname=$(echo $patch | sed 's/\.diff$//')
	< $patchdir/$patch sed -e '/^Subject:/ { N; s/\n / / }' | sed -n -e '

	# massage the patch headers
	s|^Bug: .*https\?://rt\.perl\.org/.*id=\(.*\).*|[perl #\1]|; tprepend;
	s|^Bug: .*https\?://rt\.cpan\.org/.*id=\(.*\).*|[rt.cpan.org #\1]|; tprepend;
	s|^Bug-Gentoo: ||; tprepend;
	s/^\(Subject\|Description\): //; tappend;
	s|^Origin: .*http://perl5\.git\.perl\.org/perl\.git/commit\(diff\)\?/\(.......\).*|[\2]|; tprepend;

	# post-process at the end of input
	$ { x;
		# include the version number in the patchlevel.h description (if available)
		s/List packaged patches/&'" for ${PF}(#${PATCH_VER})"'/;

		# escape any backslashes and double quotes
		s|\\|\\\\|g; s|"|\\"|g;

		# add a prefix
		s|^|\t,"'"$prefix$patchname"' - |;
		# newlines away
		s/\n/ /g; s/  */ /g;
		# add a suffix
		s/ *$/"/; p
	};
	# stop all processing
	d;
	# label: append to the hold space
	:append H; d;
	# label: prepend to the hold space
	:prepend x; H; d;
	'
done < "${WORKDIR}"/patches/series > "${S}/${patchoutput}"
echo "${patchoutput}" >> "${S}/MANIFEST"
}

src_prepare() {
	local patch
	EPATCH_OPTS+=" -p1"
	einfo "Applying patches from ${MY_P}-${PATCH_VER} ..."
	while read patch ; do
		EPATCH_SINGLE_MSG="  ${patch} ..."
		epatch "${WORKDIR}"/patches/${patch}
	done < "${WORKDIR}"/patches/series

	src_prepare_update_patchlevel_h

	if ! tc-is-static-only ; then
		ln -s ${LIBPERL} libperl$(get_libname ${SHORT_PV}) || die
		ln -s ${LIBPERL} libperl$(get_libname ) || die
	fi

	default
}

myconf() {
	# the myconf array is declared in src_configure
	myconf=( "${myconf[@]}" "$@" )
}

src_configure() {
	declare -a myconf

	export LC_ALL="C"
	[[ ${COLUMNS:-1} -ge 1 ]] || unset COLUMNS # bug #394091

	# some arches and -O do not mix :)
	use ppc && replace-flags -O? -O1

	# Perl has problems compiling with -Os in your flags with glibc
	use elibc_uclibc || replace-flags "-Os" "-O2"

	# This flag makes compiling crash in interesting ways
	filter-flags "-malign-double"

	# Fixes bug #97645
	use ppc && filter-flags "-mpowerpc-gpopt"

	# Fixes bug #143895 on gcc-4.1.1
	filter-flags "-fsched2-use-superblocks"

	use sparc && myconf -Ud_longdbl

	export BUILD_BZIP2=0
	export BZIP2_INCLUDE=${EPREFIX}/usr/include
	export BZIP2_LIB=${EPREFIX}/usr/$(get_libdir)

	export BUILD_ZLIB=False
	export ZLIB_INCLUDE=${EPREFIX}/usr/include
	export ZLIB_LIB=${EPREFIX}/usr/$(get_libdir)

	# allow either gdbm to provide ndbm (in <gdbm/ndbm.h>) or db1
	myndbm='U'
	mygdbm='U'
	mydb='U'
	if use gdbm ; then
		mygdbm='D'
		myndbm='D'
	fi
	if use berkdb ; then
		mydb='D'
		has_version '=sys-libs/db-1*' && myndbm='D'
	fi

	myconf "-${myndbm}i_ndbm" "-${mygdbm}i_gdbm" "-${mydb}i_db"

	if use alpha && [[ "$(tc-getCC)" = "ccc" ]] ; then
		ewarn "Perl will not be built with berkdb support, use gcc if you needed it..."
		myconf -Ui_db -Ui_ndbm
	fi

	use ithreads && myconf -Dusethreads

	if use debug ; then
		append-cflags "-g"
		myconf -DDEBUGGING
	elif [[ ${CFLAGS} == *-g* ]] ; then
		myconf -DDEBUGGING=-g
	else
		myconf -DDEBUGGING=none
	fi

	if [[ -n ${PERL_OLDVERSEN} ]] ; then
		local inclist=$(for v in ${PERL_OLDVERSEN}; do echo -n "${v}/${myarch}${mythreading} ${v} "; done )
		myconf -Dinc_version_list="${inclist}"
	fi

	[[ ${ELIBC} == "FreeBSD" ]] && myconf "-Dlibc=/usr/$(get_libdir)/libc.a"

	# Make sure we can do the final link #523730, need to set deployment
	# target to override hardcoded 10.3 which breaks on modern OSX
	[[ ${CHOST} == *-darwin* ]] && \
		myconf "-Dld=env MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET} $(tc-getCC)"

	# Prefix: the host system needs not to follow Gentoo multilib stuff, and in
	# Prefix itself we don't do multilib either, so make sure perl can find
	# something compatible.
	if use prefix ; then
		# Set a hook to check for each detected library whether it actually works.
		export libscheck="
			( echo 'main(){}' > '${T}'/conftest.c &&
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

	sh Configure \
		-des \
		-Duseshrplib \
		-Darchname="${myarch}" \
		-Dcc="$(tc-getCC)" \
		-Doptimize="${CFLAGS}" \
		-Dldflags="${LDFLAGS}" \
		-Dprefix="${EPREFIX}"'/usr' \
		-Dinstallprefix="${EPREFIX}"'/usr' \
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
		-Dinstallusrbinperl='n' \
		-Ud_csh \
		-Dsh="${EPREFIX}"/bin/sh \
		-Dtargetsh="${EPREFIX}"/bin/sh \
		-Uusenm \
		"${myconf[@]}" || die "Unable to configure"
}

src_test() {
	export NO_GENTOO_NETWORK_TESTS=1;
	if [[ ${EUID} == 0 ]] ; then
		ewarn "Test fails with a sandbox error (#328793) if run as root. Skipping tests..."
		return 0
	fi
	use elibc_uclibc && export MAKEOPTS+=" -j1"
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
		ln -sf ../../../../../$(get_libdir)/${LIBPERL} "${ED}"${coredir}/${LIBPERL} || die
		ln -sf ../../../../../$(get_libdir)/${LIBPERL} "${ED}"${coredir}/libperl$(get_libname ${SHORT_PV}) || die
		ln -sf ../../../../../$(get_libdir)/${LIBPERL} "${ED}"${coredir}/libperl$(get_libname) || die
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

pkg_postinst() {
	dual_scripts

	if [[ "${ROOT}" = "/" ]] ; then
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

pkg_postrm(){
	dual_scripts
}

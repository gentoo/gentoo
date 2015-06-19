# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/toolchain-binutils.eclass,v 1.142 2015/05/25 08:41:16 vapier Exp $
#
# Maintainer: Toolchain Ninjas <toolchain@gentoo.org>
#
# We install binutils into CTARGET-VERSION specific directories.  This lets
# us easily merge multiple versions for multiple targets (if we wish) and
# then switch the versions on the fly (with `binutils-config`).
#
# binutils-9999           -> live git
# binutils-9999_preYYMMDD -> nightly snapshot date YYMMDD
# binutils-#              -> normal release

if [[ -n ${BINUTILS_TYPE} ]] ; then
	BTYPE=${BINUTILS_TYPE}
else
	case ${PV} in
	9999)      BTYPE="git";;
	9999_pre*) BTYPE="snap";;
	*.*.90)    BTYPE="snap";;
	*.*.*.*.*) BTYPE="hjlu";;
	*)         BTYPE="rel";;
	esac
fi

case ${BTYPE} in
git)
	BVER="git"
	EGIT_REPO_URI="git://sourceware.org/git/binutils-gdb.git"
	inherit git-2
	;;
snap)
	BVER=${PV/9999_pre}
	;;
*)
	BVER=${BINUTILS_VER:-${PV}}
	;;
esac

inherit eutils libtool flag-o-matic gnuconfig multilib versionator unpacker
case ${EAPI:-0} in
0|1)
	EXPORT_FUNCTIONS src_unpack src_compile src_test src_install pkg_postinst pkg_postrm ;;
2|3|4|5)
	EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_test src_install pkg_postinst pkg_postrm ;;
*) die "unsupported EAPI ${EAPI}" ;;
esac

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }

DESCRIPTION="Tools necessary to build programs"
HOMEPAGE="http://sourceware.org/binutils/"

case ${BTYPE} in
	git) SRC_URI="" ;;
	snap)
		SRC_URI="ftp://gcc.gnu.org/pub/binutils/snapshots/binutils-${BVER}.tar.bz2
			ftp://sourceware.org/pub/binutils/snapshots/binutils-${BVER}.tar.bz2" ;;
	hjlu)
		SRC_URI="mirror://kernel/linux/devel/binutils/binutils-${BVER}.tar."
		version_is_at_least 2.21.51.0.5 && SRC_URI+="xz" || SRC_URI+="bz2" ;;
	rel) SRC_URI="mirror://gnu/binutils/binutils-${BVER}.tar.bz2" ;;
esac
add_src_uri() {
	[[ -z $2 ]] && return
	local a=$1
	if version_is_at_least 2.22.52.0.2 ; then
		a+=".xz"
	else
		a+=".bz2"
	fi
	set -- mirror://gentoo http://dev.gentoo.org/~vapier/dist
	SRC_URI="${SRC_URI} ${@/%//${a}}"
}
add_src_uri binutils-${BVER}-patches-${PATCHVER}.tar ${PATCHVER}
add_src_uri binutils-${BVER}-uclibc-patches-${UCLIBC_PATCHVER}.tar ${UCLIBC_PATCHVER}
add_src_uri elf2flt-${ELF2FLT_VER}.tar ${ELF2FLT_VER}

if version_is_at_least 2.18 ; then
	LICENSE="|| ( GPL-3 LGPL-3 )"
else
	LICENSE="|| ( GPL-2 LGPL-2 )"
fi
IUSE="cxx multislot multitarget nls static-libs test vanilla"
if version_is_at_least 2.19 ; then
	IUSE+=" zlib"
fi
if ! version_is_at_least 2.23.90 || [[ ${BTYPE} != "rel" ]] || is_cross || use multislot ; then
	SLOT="${BVER}"
else
	SLOT="0"
fi

RDEPEND=">=sys-devel/binutils-config-3"
in_iuse zlib && RDEPEND+=" zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )
	nls? ( sys-devel/gettext )
	sys-devel/flex
	virtual/yacc"

S=${WORKDIR}/binutils
case ${BVER} in
git) ;;
*) S=${S}-${BVER} ;;
esac

LIBPATH=/usr/$(get_libdir)/binutils/${CTARGET}/${BVER}
INCPATH=${LIBPATH}/include
DATAPATH=/usr/share/binutils-data/${CTARGET}/${BVER}
MY_BUILDDIR=${WORKDIR}/build
if is_cross ; then
	BINPATH=/usr/${CHOST}/${CTARGET}/binutils-bin/${BVER}
else
	BINPATH=/usr/${CTARGET}/binutils-bin/${BVER}
fi

tc-binutils_unpack() {
	case ${BTYPE} in
	git) git-2_src_unpack ;;
	*)   unpacker ${A} ;;
	esac
	mkdir -p "${MY_BUILDDIR}"
	[[ -d ${WORKDIR}/patch ]] && mkdir "${WORKDIR}"/patch/skip
}

# In case the ebuild wants to add a few of their own.
PATCHES=()

tc-binutils_apply_patches() {
	cd "${S}"

	if ! use vanilla ; then
		if [[ -n ${PATCHVER} ]] ; then
			EPATCH_SOURCE=${WORKDIR}/patch
			if [[ ${CTARGET} == mips* ]] ; then
				# remove gnu-hash for mips (bug #233233)
				EPATCH_EXCLUDE+=" 77_all_generate-gnu-hash.patch"
			fi
			[[ -n $(ls "${EPATCH_SOURCE}"/*.bz2 2>/dev/null) ]] \
				&& EPATCH_SUFFIX="patch.bz2" \
				|| EPATCH_SUFFIX="patch"
			epatch
		fi
		if [[ -n ${UCLIBC_PATCHVER} ]] ; then
			EPATCH_SOURCE=${WORKDIR}/uclibc-patches
			[[ -n $(ls "${EPATCH_SOURCE}"/*.bz2 2>/dev/null) ]] \
				&& EPATCH_SUFFIX="patch.bz2" \
				|| EPATCH_SUFFIX="patch"
			EPATCH_MULTI_MSG="Applying uClibc fixes ..." \
			epatch
		elif [[ ${CTARGET} == *-uclibc* ]] ; then
			# starting with binutils-2.17.50.0.17, we no longer need
			# uClibc patchsets :D
			if grep -qs 'linux-gnu' "${S}"/ltconfig ; then
				die "sorry, but this binutils doesn't yet support uClibc :("
			fi
		fi
		[[ ${#PATCHES[@]} -gt 0 ]] && epatch "${PATCHES[@]}"
		epatch_user
	fi

	# fix locale issues if possible #122216
	if [[ -e ${FILESDIR}/binutils-configure-LANG.patch ]] ; then
		einfo "Fixing misc issues in configure files"
		for f in $(find "${S}" -name configure -exec grep -l 'autoconf version 2.13' {} +) ; do
			ebegin "  Updating ${f/${S}\/}"
			patch "${f}" "${FILESDIR}"/binutils-configure-LANG.patch >& "${T}"/configure-patch.log \
				|| eerror "Please file a bug about this"
			eend $?
		done
	fi
	# fix conflicts with newer glibc #272594
	if [[ -e libiberty/testsuite/test-demangle.c ]] ; then
		sed -i 's:\<getline\>:get_line:g' libiberty/testsuite/test-demangle.c
	fi

	# Fix po Makefile generators
	sed -i \
		-e '/^datadir = /s:$(prefix)/@DATADIRNAME@:@datadir@:' \
		-e '/^gnulocaledir = /s:$(prefix)/share:$(datadir):' \
		*/po/Make-in || die "sed po's failed"

	# Run misc portage update scripts
	gnuconfig_update
	elibtoolize --portage --no-uclibc
}

toolchain-binutils_src_unpack() {
	tc-binutils_unpack
	case ${EAPI:-0} in
	0|1) toolchain-binutils_src_prepare ;;
	esac
}

toolchain-binutils_src_prepare() {
	tc-binutils_apply_patches
}

_eprefix_init() {
	has "${EAPI:-0}" 0 1 2 && ED=${D} EPREFIX= EROOT=${ROOT}
}

# Intended for ebuilds to override to set their own versioning information.
toolchain-binutils_bugurl() {
	printf "http://bugs.gentoo.org/"
}
toolchain-binutils_pkgversion() {
	printf "Gentoo ${BVER}"
	[[ -n ${PATCHVER} ]] && printf " p${PATCHVER}"
}

toolchain-binutils_src_configure() {
	_eprefix_init

	# make sure we filter $LINGUAS so that only ones that
	# actually work make it through #42033
	strip-linguas -u */po

	# keep things sane
	strip-flags

	local x
	echo
	for x in CATEGORY CBUILD CHOST CTARGET CFLAGS LDFLAGS ; do
		einfo "$(printf '%10s' ${x}:) ${!x}"
	done
	echo

	cd "${MY_BUILDDIR}"
	local myconf=()

	# enable gold if available (installed as ld.gold)
	if use cxx ; then
		if grep -q 'enable-gold=default' "${S}"/configure ; then
			myconf+=( --enable-gold )
		# old ways - remove when 2.21 is stable
		elif grep -q 'enable-gold=both/ld' "${S}"/configure ; then
			myconf+=( --enable-gold=both/ld )
		elif grep -q 'enable-gold=both/bfd' "${S}"/configure ; then
			myconf+=( --enable-gold=both/bfd )
		fi
		if grep -q -e '--enable-plugins' "${S}"/ld/configure ; then
			myconf+=( --enable-plugins )
		fi
	fi

	use nls \
		&& myconf+=( --without-included-gettext ) \
		|| myconf+=( --disable-nls )

	if in_iuse zlib ; then
		# older versions did not have an explicit configure flag
		export ac_cv_search_zlibVersion=$(usex zlib -lz no)
		myconf+=( $(use_with zlib) )
	fi

	# For bi-arch systems, enable a 64bit bfd.  This matches
	# the bi-arch logic in toolchain.eclass. #446946
	# We used to do it for everyone, but it's slow on 32bit arches. #438522
	case $(tc-arch) in
	ppc|sparc|x86) myconf+=( --enable-64-bit-bfd ) ;;
	esac

	use multitarget && myconf+=( --enable-targets=all --enable-64-bit-bfd )
	[[ -n ${CBUILD} ]] && myconf+=( --build=${CBUILD} )
	is_cross && myconf+=(
		--with-sysroot="${EPREFIX}"/usr/${CTARGET}
		--enable-poison-system-directories
	)

	# glibc-2.3.6 lacks support for this ... so rather than force glibc-2.5+
	# on everyone in alpha (for now), we'll just enable it when possible
	has_version ">=${CATEGORY}/glibc-2.5" && myconf+=( --enable-secureplt )
	has_version ">=sys-libs/glibc-2.5" && myconf+=( --enable-secureplt )

	myconf+=(
		--prefix="${EPREFIX}"/usr
		--host=${CHOST}
		--target=${CTARGET}
		--datadir="${EPREFIX}"${DATAPATH}
		--infodir="${EPREFIX}"${DATAPATH}/info
		--mandir="${EPREFIX}"${DATAPATH}/man
		--bindir="${EPREFIX}"${BINPATH}
		--libdir="${EPREFIX}"${LIBPATH}
		--libexecdir="${EPREFIX}"${LIBPATH}
		--includedir="${EPREFIX}"${INCPATH}
		--enable-obsolete
		--enable-shared
		--enable-threads
		# Newer versions (>=2.24) make this an explicit option. #497268
		--enable-install-libiberty
		--disable-werror
		--with-bugurl="$(toolchain-binutils_bugurl)"
		--with-pkgversion="$(toolchain-binutils_pkgversion)"
		$(use_enable static-libs static)
		${EXTRA_ECONF}
		# Disable modules that are in a combined binutils/gdb tree. #490566
		--disable-{gdb,libdecnumber,readline,sim}
		# Strip out broken static link flags.
		# https://gcc.gnu.org/PR56750
		--without-stage1-ldflags
	)
	echo ./configure "${myconf[@]}"
	"${S}"/configure "${myconf[@]}" || die

	# Prevent makeinfo from running in releases.  It may not always be
	# installed, and older binutils may fail with newer texinfo.
	# Besides, we never patch the doc files anyways, so regenerating
	# in the first place is useless. #193364
	# For older versions, it means we don't get any info pages at all.
	# Oh well, tough luck. #294617
	if [[ -e ${S}/gas/doc/as.info ]] || ! version_is_at_least 2.24 ; then
		sed -i \
			-e '/^MAKEINFO/s:=.*:= true:' \
			Makefile || die
	fi
}

toolchain-binutils_src_compile() {
	_eprefix_init
	case ${EAPI:-0} in
	0|1) toolchain-binutils_src_configure ;;
	esac

	cd "${MY_BUILDDIR}"
	emake all || die "emake failed"

	# only build info pages if we user wants them, and if
	# we have makeinfo (may not exist when we bootstrap)
	if type -p makeinfo > /dev/null ; then
		emake info || die "make info failed"
	fi
	# we nuke the manpages when we're left with junk
	# (like when we bootstrap, no perl -> no manpages)
	find . -name '*.1' -a -size 0 -delete

	# elf2flt only works on some arches / targets
	if [[ -n ${ELF2FLT_VER} ]] && [[ ${CTARGET} == *linux* || ${CTARGET} == *-elf* ]] ; then
		cd "${WORKDIR}"/elf2flt-${ELF2FLT_VER}

		local x supported_arches=$(sed -n '/defined(TARGET_/{s:^.*TARGET_::;s:)::;p}' elf2flt.c | sort -u)
		for x in ${supported_arches} UNSUPPORTED ; do
			[[ ${CTARGET} == ${x}* ]] && break
		done

		if [[ ${x} != "UNSUPPORTED" ]] ; then
			append-flags -I"${S}"/include
			myconf+=(
				--with-bfd-include-dir=${MY_BUILDDIR}/bfd
				--with-libbfd=${MY_BUILDDIR}/bfd/libbfd.a
				--with-libiberty=${MY_BUILDDIR}/libiberty/libiberty.a
				--with-binutils-ldscript-dir="${EPREFIX}"${LIBPATH}/ldscripts
			)
			echo ./configure "${myconf[@]}"
			./configure "${myconf[@]}" || die
			emake || die "make elf2flt failed"
		fi
	fi
}

toolchain-binutils_src_test() {
	cd "${MY_BUILDDIR}"
	emake -k check || die "check failed :("
}

toolchain-binutils_src_install() {
	_eprefix_init
	local x d

	cd "${MY_BUILDDIR}"
	emake DESTDIR="${D}" tooldir="${EPREFIX}${LIBPATH}" install || die
	rm -rf "${ED}"/${LIBPATH}/bin
	use static-libs || find "${ED}" -name '*.la' -delete

	# Newer versions of binutils get fancy with ${LIBPATH} #171905
	cd "${ED}"/${LIBPATH}
	for d in ../* ; do
		[[ ${d} == ../${BVER} ]] && continue
		mv ${d}/* . || die
		rmdir ${d} || die
	done

	# Now we collect everything intp the proper SLOT-ed dirs
	# When something is built to cross-compile, it installs into
	# /usr/$CHOST/ by default ... we have to 'fix' that :)
	if is_cross ; then
		cd "${ED}"/${BINPATH}
		for x in * ; do
			mv ${x} ${x/${CTARGET}-}
		done

		if [[ -d ${ED}/usr/${CHOST}/${CTARGET} ]] ; then
			mv "${ED}"/usr/${CHOST}/${CTARGET}/include "${ED}"/${INCPATH}
			mv "${ED}"/usr/${CHOST}/${CTARGET}/lib/* "${ED}"/${LIBPATH}/
			rm -r "${ED}"/usr/${CHOST}/{include,lib}
		fi
	fi
	insinto ${INCPATH}
	local libiberty_headers=(
		# Not all the libiberty headers.  See libiberty/Makefile.in:install_to_libdir.
		demangle.h
		dyn-string.h
		fibheap.h
		hashtab.h
		libiberty.h
		objalloc.h
		splay-tree.h
	)
	doins "${libiberty_headers[@]/#/${S}/include/}" || die
	if [[ -d ${ED}/${LIBPATH}/lib ]] ; then
		mv "${ED}"/${LIBPATH}/lib/* "${ED}"/${LIBPATH}/
		rm -r "${ED}"/${LIBPATH}/lib
	fi

	# Insert elf2flt where appropriate
	if [[ -x ${WORKDIR}/elf2flt-${ELF2FLT_VER}/elf2flt ]] ; then
		cd "${WORKDIR}"/elf2flt-${ELF2FLT_VER}
		insinto ${LIBPATH}/ldscripts
		doins elf2flt.ld || die "doins elf2flt.ld failed"
		exeinto ${BINPATH}
		doexe elf2flt flthdr || die "doexe elf2flt flthdr failed"
		mv "${ED}"/${BINPATH}/{ld,ld.real} || die
		newexe ld-elf2flt ld || die "doexe ld-elf2flt failed"
		newdoc README README.elf2flt
	fi

	# Generate an env.d entry for this binutils
	insinto /etc/env.d/binutils
	cat <<-EOF > "${T}"/env.d
		TARGET="${CTARGET}"
		VER="${BVER}"
		LIBPATH="${EPREFIX}${LIBPATH}"
	EOF
	newins "${T}"/env.d ${CTARGET}-${BVER}

	# Handle documentation
	if ! is_cross ; then
		cd "${S}"
		dodoc README
		docinto bfd
		dodoc bfd/ChangeLog* bfd/README bfd/PORTING bfd/TODO
		docinto binutils
		dodoc binutils/ChangeLog binutils/NEWS binutils/README
		docinto gas
		dodoc gas/ChangeLog* gas/CONTRIBUTORS gas/NEWS gas/README*
		docinto gprof
		dodoc gprof/ChangeLog* gprof/TEST gprof/TODO gprof/bbconv.pl
		docinto ld
		dodoc ld/ChangeLog* ld/README ld/NEWS ld/TODO
		docinto libiberty
		dodoc libiberty/ChangeLog* libiberty/README
		docinto opcodes
		dodoc opcodes/ChangeLog*
	fi
	# Remove shared info pages
	rm -f "${ED}"/${DATAPATH}/info/{dir,configure.info,standards.info}
	# Trim all empty dirs
	find "${ED}" -depth -type d -exec rmdir {} + 2>/dev/null
}

toolchain-binutils_pkg_postinst() {
	_eprefix_init
	# Make sure this ${CTARGET} has a binutils version selected
	[[ -e ${EROOT}/etc/env.d/binutils/config-${CTARGET} ]] && return 0
	binutils-config ${CTARGET}-${BVER}
}

toolchain-binutils_pkg_postrm() {
	_eprefix_init
	local current_profile=$(binutils-config -c ${CTARGET})

	# If no other versions exist, then uninstall for this
	# target ... otherwise, switch to the newest version
	# Note: only do this if this version is unmerged.  We
	#       rerun binutils-config if this is a remerge, as
	#       we want the mtimes on the symlinks updated (if
	#       it is the same as the current selected profile)
	if [[ ! -e ${EPREFIX}${BINPATH}/ld ]] && [[ ${current_profile} == ${CTARGET}-${BVER} ]] ; then
		local choice=$(binutils-config -l | grep ${CTARGET} | awk '{print $2}')
		choice=${choice//$'\n'/ }
		choice=${choice/* }
		if [[ -z ${choice} ]] ; then
			env -i ROOT="${ROOT}" binutils-config -u ${CTARGET}
		else
			binutils-config ${choice}
		fi
	elif [[ $(CHOST=${CTARGET} binutils-config -c) == ${CTARGET}-${BVER} ]] ; then
		binutils-config ${CTARGET}-${BVER}
	fi
}

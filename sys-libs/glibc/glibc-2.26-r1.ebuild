# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-glibc

DESCRIPTION="GNU libc6 (also called glibc2) C library"
HOMEPAGE="https://www.gnu.org/software/libc/libc.html"

LICENSE="LGPL-2.1+ BSD HPND ISC inner-net rc PCRE"
RESTRICT="strip" # strip ourself #46186
EMULTILIB_PKG="true"

# Configuration variables

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URIS="git://sourceware.org/git/glibc.git"
	EGIT_SOURCEDIRS="${S}"
	inherit git-2
else
	# KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	KEYWORDS=""
fi

RELEASE_VER=${PV}

GCC_BOOTSTRAP_VER="4.7.3-r1"
# patches live at https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo/src/patchsets/glibc/
PATCH_VER="0"                                  # Gentoo patchset
: ${NPTL_KERN_VER:="2.6.32"}                   # min kernel version nptl requires

IUSE="audit caps debug gd hardened multilib nscd +rpc selinux systemtap profile suid vanilla crosscompile_opts_headers-only"

# Here's how the cross-compile logic breaks down ...
#  CTARGET - machine that will target the binaries
#  CHOST   - machine that will host the binaries
#  CBUILD  - machine that will build the binaries
# If CTARGET != CHOST, it means you want a libc for cross-compiling.
# If CHOST != CBUILD, it means you want to cross-compile the libc.
#  CBUILD = CHOST = CTARGET    - native build/install
#  CBUILD != (CHOST = CTARGET) - cross-compile a native build
#  (CBUILD = CHOST) != CTARGET - libc for cross-compiler
#  CBUILD != CHOST != CTARGET  - cross-compile a libc for a cross-compiler
# For install paths:
#  CHOST = CTARGET  - install into /
#  CHOST != CTARGET - install into /usr/CTARGET/

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

# Why SLOT 2.2 you ask yourself while sippin your tea ?
# Everyone knows 2.2 > 0, duh.
SLOT="2.2"

# General: We need a new-enough binutils/gcc to match upstream baseline.
# arch: we need to make sure our binutils/gcc supports TLS.
COMMON_DEPEND="
	nscd? ( selinux? (
		audit? ( sys-process/audit )
		caps? ( sys-libs/libcap )
	) )
	suid? ( caps? ( sys-libs/libcap ) )
	selinux? ( sys-libs/libselinux )
"
DEPEND="${COMMON_DEPEND}
	>=app-misc/pax-utils-0.1.10
	!<sys-apps/sandbox-1.6
	!<sys-apps/portage-2.1.2"
RDEPEND="${COMMON_DEPEND}
	!sys-kernel/ps3-sources
	sys-apps/gentoo-functions
	!sys-libs/nss-db"

if [[ ${CATEGORY} == cross-* ]] ; then
	DEPEND+=" !crosscompile_opts_headers-only? (
		>=${CATEGORY}/binutils-2.24
		>=${CATEGORY}/gcc-4.7
	)"
	[[ ${CATEGORY} == *-linux* ]] && DEPEND+=" ${CATEGORY}/linux-headers"
else
	DEPEND+="
		>=sys-devel/binutils-2.24
		>=sys-devel/gcc-4.7
		virtual/os-headers"
	RDEPEND+=" vanilla? ( !sys-libs/timezone-data )"
	PDEPEND+=" !vanilla? ( sys-libs/timezone-data )"
fi

upstream_uris() {
	echo mirror://gnu/glibc/$1 ftp://sourceware.org/pub/glibc/{releases,snapshots}/$1 mirror://gentoo/$1
}
gentoo_uris() {
	local devspace="HTTP~vapier/dist/URI HTTP~tamiko/distfiles/URI HTTP~dilfridge/distfiles/URI HTTP~slyfox/distfiles/URI"
	devspace=${devspace//HTTP/https://dev.gentoo.org/}
	echo mirror://gentoo/$1 ${devspace//URI/$1}
}
SRC_URI=$(
	[[ -z ${EGIT_REPO_URIS} ]] && upstream_uris ${P}.tar.xz
	[[ -n ${PATCH_VER}      ]] && gentoo_uris ${P}-patches-${PATCH_VER}.tar.bz2
)
SRC_URI+=" ${GCC_BOOTSTRAP_VER:+multilib? ( $(gentoo_uris gcc-${GCC_BOOTSTRAP_VER}-multilib-bootstrap.tar.bz2) )}"

#
# the phases
#

pkg_pretend() {
    check_devpts

	# Prevent native builds from downgrading.
	if [[ ${MERGE_TYPE} != "buildonly" ]] && \
	   [[ ${ROOT} == "/" ]] && \
	   [[ ${CBUILD} == ${CHOST} ]] && \
	   [[ ${CHOST} == ${CTARGET} ]] ; then
		# The high rev # is to allow people to downgrade between -r# versions.
		# We want to block 2.20->2.19, but 2.20-r3->2.20-r2 should be fine.
		# Hopefully we never actually use a r# this high.
		if has_version ">${CATEGORY}/${P}-r10000" ; then
			eerror "Sanity check to keep you from breaking your system:"
			eerror " Downgrading glibc is not supported and a sure way to destruction"
			die "aborting to save your system"
		fi

		if ! glibc_run_test '#include <pwd.h>\nint main(){return getpwuid(0)==0;}\n'
		then
			eerror "Your patched vendor kernel is broken.  You need to get an"
			eerror "update from whoever is providing the kernel to you."
			eerror "https://sourceware.org/bugzilla/show_bug.cgi?id=5227"
			eerror "http://bugs.gentoo.org/262698"
			die "keeping your system alive, say thank you"
		fi

		if ! glibc_run_test '#include <unistd.h>\n#include <sys/syscall.h>\nint main(){return syscall(1000)!=-1;}\n'
		then
			eerror "Your old kernel is broken.  You need to update it to"
			eerror "a newer version as syscall(<bignum>) will break."
			eerror "http://bugs.gentoo.org/279260"
			die "keeping your system alive, say thank you"
		fi
	fi

	# users have had a chance to phase themselves, time to give em the boot
	if [[ -e ${EROOT}/etc/locale.gen ]] && [[ -e ${EROOT}/etc/locales.build ]] ; then
		eerror "You still haven't deleted ${EROOT}/etc/locales.build."
		eerror "Do so now after making sure ${EROOT}/etc/locale.gen is kosher."
		die "lazy upgrader detected"
	fi

	if [[ ${CTARGET} == i386-* ]] ; then
		eerror "i386 CHOSTs are no longer supported."
		eerror "Chances are you don't actually want/need i386."
		eerror "Please read http://www.gentoo.org/doc/en/change-chost.xml"
		die "please fix your CHOST"
	fi

	if [[ -e /proc/xen ]] && [[ $(tc-arch) == "x86" ]] && ! is-flag -mno-tls-direct-seg-refs ; then
		ewarn "You are using Xen but don't have -mno-tls-direct-seg-refs in your CFLAGS."
		ewarn "This will result in a 50% performance penalty when running with a 32bit"
		ewarn "hypervisor, which is probably not what you want."
	fi

	use hardened && ! tc-enables-pie && \
		ewarn "PIE hardening not applied, as your compiler doesn't default to PIE"

	# Make sure host system is up to date #394453
	if has_version '<sys-libs/glibc-2.13' && \
	   [[ -n $(scanelf -qys__guard -F'#s%F' "${EROOT}"/lib*/l*-*.so) ]]
	then
		ebegin "Scanning system for __guard to see if you need to rebuild first ..."
		local files=$(
			scanelf -qys__guard -F'#s%F' \
				"${EROOT}"/*bin/ \
				"${EROOT}"/lib* \
				"${EROOT}"/usr/*bin/ \
				"${EROOT}"/usr/lib* | \
				egrep -v \
					-e "^${EROOT}/lib.*/(libc|ld)-2.*.so$" \
					-e "^${EROOT}/sbin/(ldconfig|sln)$"
		)
		[[ -z ${files} ]]
		if ! eend $? ; then
			eerror "Your system still has old SSP __guard symbols.  You need to"
			eerror "rebuild all the packages that provide these files first:"
			eerror "${files}"
			die "old __guard detected"
		fi
	fi
}

src_unpack() {
	[[ -n ${GCC_BOOTSTRAP_VER} ]] && use multilib && unpack gcc-${GCC_BOOTSTRAP_VER}-multilib-bootstrap.tar.bz2

	setup_env

	# Check NPTL support _before_ we unpack things to save some time
	want_nptl && check_nptl_support

	if [[ -n ${EGIT_REPO_URIS} ]] ; then
		local i d
		for ((i=0; i<${#EGIT_REPO_URIS[@]}; ++i)) ; do
			EGIT_REPO_URI=${EGIT_REPO_URIS[$i]}
			EGIT_SOURCEDIR=${EGIT_SOURCEDIRS[$i]}
			git-2_src_unpack
		done
	else
		unpack_pkg
	fi

	cd "${S}"
	touch locale/C-translit.h #185476 #218003
	[[ -n ${LT_VER}     ]] && unpack_pkg linuxthreads ${LT_VER}
	[[ -n ${PORTS_VER}  ]] && unpack_pkg ports ${PORTS_VER}
	[[ -n ${LIBIDN_VER} ]] && unpack_pkg libidn

	if [[ -n ${PATCH_VER} ]] ; then
		cd "${WORKDIR}"
		unpack glibc-${RELEASE_VER}-patches-${PATCH_VER}.tar.bz2
		# pull out all the addons
		local d
		for d in extra/*/configure ; do
			d=${d%/configure}
			[[ -d ${S}/${d} ]] && die "${d} already exists in \${S}"
			mv "${d}" "${S}" || die "moving ${d} failed"
		done
	fi
}

src_prepare() {
	# XXX: We should do the branchupdate, before extracting the manpages and
	# infopages else it does not help much (mtimes change if there is a change
	# to them with branchupdate)
	if [[ -n ${BRANCH_UPDATE} ]] ; then
		epatch "${DISTDIR}"/glibc-${RELEASE_VER}-branch-update-${BRANCH_UPDATE}.patch.bz2

		# Snapshot date patch
		einfo "Patching version to display snapshot date ..."
		sed -i -e "s:\(#define RELEASE\).*:\1 \"${BRANCH_UPDATE}\":" version.h
	fi

	if [[ -n ${PATCH_VER} ]] && ! use vanilla ; then
		EPATCH_MULTI_MSG="Applying Gentoo Glibc Patchset ${RELEASE_VER}-${PATCH_VER} ..." \
		EPATCH_EXCLUDE=${GLIBC_PATCH_EXCLUDE} \
		EPATCH_SUFFIX="patch" \
		ARCH=$(tc-arch) \
		epatch "${WORKDIR}"/patches
	fi

	if just_headers ; then
		if [[ -e ports/sysdeps/mips/preconfigure ]] ; then
			# mips peeps like to screw with us.  if building headers,
			# we don't have a real compiler, so we can't let them
			# insert -mabi on us.
			sed -i '/CPPFLAGS=.*-mabi/s|.*|:|' ports/sysdeps/mips/preconfigure || die
			find ports/sysdeps/mips/ -name Makefile -exec sed -i '/^CC.*-mabi=/s:-mabi=.*:-D_MIPS_SZPTR=32:' {} +
		fi
	fi

	eapply_user

	gnuconfig_update

	cd "${WORKDIR}"
	find . -type f '(' -size 0 -o -name "*.orig" ')' -delete
	find . -name configure -exec touch {} +

	eprefixify extra/locale/locale-gen

	# Fix permissions on some of the scripts.
	chmod u+x "${S}"/scripts/*.sh

	cd "${S}"

	if use hardened ; then
		# We don't enable these for non-hardened as the output is very terse --
		# it only states that a crash happened.  The default upstream behavior
		# includes backtraces and symbols.
		einfo "Installing Hardened Gentoo SSP and FORTIFY_SOURCE handler"
		cp "${FILESDIR}"/2.20/glibc-2.20-gentoo-stack_chk_fail.c debug/stack_chk_fail.c || die
		cp "${FILESDIR}"/2.25/glibc-2.25-gentoo-chk_fail.c debug/chk_fail.c || die

		if use debug ; then
			# Allow SIGABRT to dump core on non-hardened systems, or when debug is requested.
			sed -i \
				-e '/^CFLAGS-backtrace.c/ iCPPFLAGS-stack_chk_fail.c = -DSSP_SMASH_DUMPS_CORE' \
				-e '/^CFLAGS-backtrace.c/ iCPPFLAGS-chk_fail.c = -DSSP_SMASH_DUMPS_CORE' \
				debug/Makefile || die
		fi
	fi

	case $(gcc-fullversion) in
	4.8.[0-3]|4.9.0)
		eerror "You need to switch to a newer compiler; gcc-4.8.[0-3] and gcc-4.9.0 miscompile"
		eerror "glibc.  See https://bugs.gentoo.org/547420 for details."
		die "need to switch compilers #547420"
		;;
	esac
}

glibc_do_configure() {
	# Glibc does not work with gold (for various reasons) #269274.
	tc-ld-disable-gold

	dump_toolchain_settings "Configuring glibc for $1"

	local myconf=()

	# set addons
	pushd "${S}" > /dev/null
	local addons=$(echo */configure | sed \
		-e 's:/configure::g' \
		-e 's:\(linuxthreads\|nptl\|rtkaio\|glibc-compat\)\( \|$\)::g' \
		-e 's: \+$::' \
		-e 's! !,!g' \
		-e 's!^!,!' \
		-e '/^,\*$/d')
	[[ -d ports ]] && addons+=",ports"
	popd > /dev/null

	if has_version '<sys-libs/glibc-2.13' ; then
		myconf+=( --enable-old-ssp-compat )
	fi

	if version_is_at_least 2.25 ; then
		myconf+=( --enable-stack-protector=all )
	fi

	if version_is_at_least 2.25 ; then
		myconf+=( --enable-stackguard-randomization )
	else
		myconf+=( $(use_enable hardened stackguard-randomization) )
	fi

	[[ $(tc-is-softfloat) == "yes" ]] && myconf+=( --without-fp )

	if [[ $1 == "linuxthreads" ]] ; then
		if want_tls ; then
			myconf+=( --with-tls )

			if ! want__thread || use glibc-compat20 || [[ ${LT_KER_VER} == 2.[02].* ]] ; then
				myconf+=( --without-__thread )
			else
				myconf+=( --with-__thread )
			fi
		else
			myconf+=( --without-tls --without-__thread )
		fi

		myconf+=( --disable-sanity-checks )
		addons="linuxthreads${addons}"
		myconf+=( --enable-kernel=${LT_KER_VER} )
	elif [[ $1 == "nptl" ]] ; then
		# Newer versions require nptl, so there is no addon for it.
		version_is_at_least 2.20 || addons="nptl${addons}"
		myconf+=( --enable-kernel=${NPTL_KERN_VER} )
	else
		die "invalid pthread option"
	fi
	myconf+=( --enable-add-ons="${addons#,}" )

	# Since SELinux support is only required for nscd, only enable it if:
	# 1. USE selinux
	# 2. only for the primary ABI on multilib systems
	# 3. Not a crosscompile
	if ! is_crosscompile && use selinux ; then
		if use multilib ; then
			if is_final_abi ; then
				myconf+=( --with-selinux )
			else
				myconf+=( --without-selinux )
			fi
		else
			myconf+=( --with-selinux )
		fi
	else
		myconf+=( --without-selinux )
	fi

	# Force a few tests where we always know the answer but
	# configure is incapable of finding it.
	if is_crosscompile ; then
		export \
			libc_cv_c_cleanup=yes \
			libc_cv_forced_unwind=yes
	fi

	myconf+=(
		--without-cvs
		--disable-werror
		--enable-bind-now
		--build=${CBUILD_OPT:-${CBUILD}}
		--host=${CTARGET_OPT:-${CTARGET}}
		$(use_enable profile)
		$(use_with gd)
		--with-headers=$(alt_build_headers)
		--prefix="${EPREFIX}/usr"
		--sysconfdir="${EPREFIX}/etc"
		--localstatedir="${EPREFIX}/var"
		--libdir='$(prefix)'/$(get_libdir)
		--mandir='$(prefix)'/share/man
		--infodir='$(prefix)'/share/info
		--libexecdir='$(libdir)'/misc/glibc
		--with-bugurl=http://bugs.gentoo.org/
		--with-pkgversion="$(glibc_banner)"
		$(use_multiarch || echo --disable-multi-arch)
		$(in_iuse rpc && use_enable rpc obsolete-rpc || echo --enable-obsolete-rpc)
		$(in_iuse systemtap && use_enable systemtap)
		$(in_iuse nscd && use_enable nscd)
		${EXTRA_ECONF}
	)

	# We rely on sys-libs/timezone-data for timezone tools normally.
	if version_is_at_least 2.23 ; then
		myconf+=( $(use_enable vanilla timezone-tools) )
	fi

	# These libs don't have configure flags.
	ac_cv_lib_audit_audit_log_user_avc_message=$(in_iuse audit && usex audit || echo no)
	ac_cv_lib_cap_cap_init=$(in_iuse caps && usex caps || echo no)

	# There is no configure option for this and we need to export it
	# since the glibc build will re-run configure on itself
	export libc_cv_rootsbindir="${EPREFIX}/sbin"
	export libc_cv_slibdir="${EPREFIX}/$(get_libdir)"

	# We take care of patching our binutils to use both hash styles,
	# and many people like to force gnu hash style only, so disable
	# this overriding check.  #347761
	export libc_cv_hashstyle=no

	# Overtime, generating info pages can be painful.  So disable this for
	# versions older than the latest stable to avoid the issue (this ver
	# should be updated from time to time).  #464394 #465816
	if ! version_is_at_least 2.17 ; then
		export ac_cv_prog_MAKEINFO=:
	fi

	local builddir=$(builddir "$1")
	mkdir -p "${builddir}"
	cd "${builddir}"
	set -- "${S}"/configure "${myconf[@]}"
	echo "$@"
	"$@" || die "failed to configure glibc"

	# ia64 static cross-compilers are a pita in so much that they
	# can't produce static ELFs (as the libgcc.a is broken).  so
	# disable building of the programs for those targets if it
	# doesn't work.
	# XXX: We could turn this into a compiler test, but ia64 is
	# the only one that matters, so this should be fine for now.
	if is_crosscompile && [[ ${CTARGET} == ia64* ]] ; then
		sed -i '1i+link-static = touch $@' config.make
	fi

	# If we're trying to migrate between ABI sets, we need
	# to lie and use a local copy of gcc.  Like if the system
	# is built with MULTILIB_ABIS="amd64 x86" but we want to
	# add x32 to it, gcc/glibc don't yet support x32.
	if [[ -n ${GCC_BOOTSTRAP_VER} ]] && use multilib ; then
		echo 'main(){}' > "${T}"/test.c
		if ! $(tc-getCC ${CTARGET}) ${CFLAGS} ${LDFLAGS} "${T}"/test.c -Wl,-emain -lgcc 2>/dev/null ; then
			sed -i -e '/^CC = /s:$: -B$(objdir)/../'"gcc-${GCC_BOOTSTRAP_VER}/${ABI}:" config.make || die
			mkdir -p sunrpc
			cp $(which rpcgen) sunrpc/cross-rpcgen || die
			touch -t 202001010101 sunrpc/cross-rpcgen || die
		fi
	fi
}

glibc_headers_configure() {
	export ABI=default

	local builddir=$(builddir "headers")
	mkdir -p "${builddir}"
	cd "${builddir}"

	# if we don't have a compiler yet, we can't really test it now ...
	# hopefully they don't affect header generation, so let's hope for
	# the best here ...
	local v vars=(
		ac_cv_header_cpuid_h=yes
		libc_cv_{386,390,alpha,arm,hppa,ia64,mips,{powerpc,sparc}{,32,64},sh,x86_64}_tls=yes
		libc_cv_asm_cfi_directives=yes
		libc_cv_broken_visibility_attribute=no
		libc_cv_c_cleanup=yes
		libc_cv_forced_unwind=yes
		libc_cv_gcc___thread=yes
		libc_cv_mlong_double_128=yes
		libc_cv_mlong_double_128ibm=yes
		libc_cv_ppc_machine=yes
		libc_cv_ppc_rel16=yes
		libc_cv_predef_fortify_source=no
		libc_cv_visibility_attribute=yes
		libc_cv_z_combreloc=yes
		libc_cv_z_execstack=yes
		libc_cv_z_initfirst=yes
		libc_cv_z_nodelete=yes
		libc_cv_z_nodlopen=yes
		libc_cv_z_relro=yes
		libc_mips_abi=${ABI}
		libc_mips_float=$([[ $(tc-is-softfloat) == "yes" ]] && echo soft || echo hard)
		# These libs don't have configure flags.
		ac_cv_lib_audit_audit_log_user_avc_message=no
		ac_cv_lib_cap_cap_init=no
	)
	if ! version_is_at_least 2.25 ; then
		vars+=(
			libc_cv_predef_stack_protector=no
		)
	fi
	einfo "Forcing cached settings:"
	for v in "${vars[@]}" ; do
		einfo " ${v}"
		export ${v}
	done

	# Blow away some random CC settings that screw things up. #550192
	if [[ -d ${S}/sysdeps/mips ]]; then
		pushd "${S}"/sysdeps/mips >/dev/null
		sed -i -e '/^CC +=/s:=.*:= -D_MIPS_SZPTR=32:' mips32/Makefile mips64/n32/Makefile || die
		sed -i -e '/^CC +=/s:=.*:= -D_MIPS_SZPTR=64:' mips64/n64/Makefile || die
		if version_is_at_least 2.21 ; then
			# Force the mips ABI to the default.  This is OK because the set of
			# installed headers in this phase is the same between the 3 ABIs.
			# If this ever changes, this hack will break, but that's unlikely
			# as glibc discourages that behavior.
			# https://crbug.com/647033
			sed -i -e 's:abiflag=.*:abiflag=_ABIO32:' preconfigure || die
		fi
		popd >/dev/null
	fi

	local myconf=()
	myconf+=(
		--disable-sanity-checks
		--enable-hacker-mode
		--without-cvs
		--disable-werror
		--enable-bind-now
		--build=${CBUILD_OPT:-${CBUILD}}
		--host=${CTARGET_OPT:-${CTARGET}}
		--with-headers=$(alt_build_headers)
		--prefix="${EPREFIX}/usr"
		${EXTRA_ECONF}
	)

	local addons
	[[ -d ${S}/ports ]] && addons+=",ports"
	# Newer versions require nptl, so there is no addon for it.
	version_is_at_least 2.20 || addons+=",nptl"
	myconf+=( --enable-add-ons="${addons#,}" )

	# Nothing is compiled here which would affect the headers for the target.
	# So forcing CC/CFLAGS is sane.
	set -- "${S}"/configure "${myconf[@]}"
	echo "$@"
	CC="$(tc-getBUILD_CC)" \
	CFLAGS="-O1 -pipe" \
	CPPFLAGS="-U_FORTIFY_SOURCE" \
	LDFLAGS="" \
	"$@" || die "failed to configure glibc"
}

do_src_configure() {
	if just_headers ; then
		glibc_headers_configure
	else
		want_linuxthreads && glibc_do_configure linuxthreads
		want_nptl && glibc_do_configure nptl
	fi
}

src_configure() {
	foreach_abi do_src_configure
}

do_src_compile() {
	local t
	for t in linuxthreads nptl ; do
		if want_${t} ; then
			emake -C "$(builddir ${t})" || die "make ${t} for ${ABI} failed"
		fi
	done
}

src_compile() {
	if just_headers ; then
		return
	fi

	foreach_abi do_src_compile
}

glibc_src_test() {
	cd "$(builddir $1)"
	nonfatal emake -j1 check && return 0
	einfo "make check failed - re-running with --keep-going to get the rest of the results"
	nonfatal emake -j1 -k check
	ewarn "make check failed for ${ABI}-${CTARGET}-$1"
	return 1
}

glibc_do_src_test() {
	local ret=0 t
	for t in linuxthreads nptl ; do
		if want_${t} ; then
			glibc_src_test ${t}
			: $(( ret |= $? ))
		fi
	done
	return ${ret}
}

src_test() {
	# Give tests more time to complete.
	export TIMEOUTFACTOR=5

	foreach_abi toolchain-glibc_do_src_test || die "tests failed"
}

glibc_do_src_install() {
	local builddir=$(builddir $(want_linuxthreads && echo linuxthreads || echo nptl))
	cd "${builddir}"

	emake install_root="${D}$(alt_prefix)" install || die

	if want_linuxthreads && want_nptl ; then
		einfo "Installing NPTL to $(alt_libdir)/tls/..."
		cd "$(builddir nptl)"
		dodir $(alt_libdir)/tls $(alt_usrlibdir)/nptl

		local l src_lib
		for l in libc libm librt libpthread libthread_db ; do
			# take care of shared lib first ...
			l=${l}.so
			if [[ -e ${l} ]] ; then
				src_lib=${l}
			else
				src_lib=$(eval echo */${l})
			fi
			cp -a ${src_lib} "${ED}"$(alt_libdir)/tls/${l} || die "copying nptl ${l}"
			fperms a+rx $(alt_libdir)/tls/${l}
			dosym ${l} $(alt_libdir)/tls/$(scanelf -qSF'%S#F' ${src_lib})

			# then grab the linker script or the symlink ...
			if [[ -L ${ED}$(alt_usrlibdir)/${l} ]] ; then
				dosym $(alt_libdir)/tls/${l} $(alt_usrlibdir)/nptl/${l}
			else
				sed \
					-e "s:/${l}:/tls/${l}:g" \
					-e "s:/${l/%.so/_nonshared.a}:/nptl/${l/%.so/_nonshared.a}:g" \
					"${ED}"$(alt_usrlibdir)/${l} > "${ED}"$(alt_usrlibdir)/nptl/${l}
			fi

			# then grab the static lib ...
			src_lib=${src_lib/%.so/.a}
			[[ ! -e ${src_lib} ]] && src_lib=${src_lib/%.a/_pic.a}
			cp -a ${src_lib} "${ED}"$(alt_usrlibdir)/nptl/ || die "copying nptl ${src_lib}"
			src_lib=${src_lib/%.a/_nonshared.a}
			if [[ -e ${src_lib} ]] ; then
				cp -a ${src_lib} "${ED}"$(alt_usrlibdir)/nptl/ || die "copying nptl ${src_lib}"
			fi
		done

		# use the nptl linker instead of the linuxthreads one as the linuxthreads
		# one may lack TLS support and that can be really bad for business
		cp -a elf/ld.so "${ED}"$(alt_libdir)/$(scanelf -qSF'%S#F' elf/ld.so) || die "copying nptl interp"
	fi

	# Normally real_pv is ${PV}. Live ebuilds are exception, there we need
	# to infer upstream version:
	# '#define VERSION "2.26.90"' -> '2.26.90'
	local upstream_pv=$(sed -n -r 's/#define VERSION "(.*)"/\1/p' "${S}"/version.h)
	# Newer versions get fancy with libm linkage to include vectorized support.
	# While we don't really need a ldscript here, portage QA checks get upset.
	if [[ -e ${ED}$(alt_usrlibdir)/libm-${upstream_pv}.a ]] ; then
		dosym ../../$(get_libdir)/libm-${upstream_pv}.so $(alt_usrlibdir)/libm-${upstream_pv}.so
	fi

	# We'll take care of the cache ourselves
	rm -f "${ED}"/etc/ld.so.cache

	# Everything past this point just needs to be done once ...
	is_final_abi || return 0

	# Make sure the non-native interp can be found on multilib systems even
	# if the main library set isn't installed into the right place.  Maybe
	# we should query the active gcc for info instead of hardcoding it ?
	local i ldso_abi ldso_name
	local ldso_abi_list=(
		# x86
		amd64   /lib64/ld-linux-x86-64.so.2
		x32     /libx32/ld-linux-x32.so.2
		x86     /lib/ld-linux.so.2
		# mips
		o32     /lib/ld.so.1
		n32     /lib32/ld.so.1
		n64     /lib64/ld.so.1
		# powerpc
		ppc     /lib/ld.so.1
		ppc64   /lib64/ld64.so.1
		# s390
		s390    /lib/ld.so.1
		s390x   /lib/ld64.so.1
		# sparc
		sparc32 /lib/ld-linux.so.2
		sparc64 /lib64/ld-linux.so.2
	)
	case $(tc-endian) in
	little)
		ldso_abi_list+=(
			# arm
			arm64   /lib/ld-linux-aarch64.so.1
		)
		;;
	big)
		ldso_abi_list+=(
			# arm
			arm64   /lib/ld-linux-aarch64_be.so.1
		)
		;;
	esac
	if [[ ${SYMLINK_LIB} == "yes" ]] && [[ ! -e ${ED}/$(alt_prefix)/lib ]] ; then
		dosym $(get_abi_LIBDIR ${DEFAULT_ABI}) $(alt_prefix)/lib
	fi
	for (( i = 0; i < ${#ldso_abi_list[@]}; i += 2 )) ; do
		ldso_abi=${ldso_abi_list[i]}
		has ${ldso_abi} $(get_install_abis) || continue

		ldso_name="$(alt_prefix)${ldso_abi_list[i+1]}"
		if [[ ! -L ${ED}/${ldso_name} && ! -e ${ED}/${ldso_name} ]] ; then
			dosym ../$(get_abi_LIBDIR ${ldso_abi})/${ldso_name##*/} ${ldso_name}
		fi
	done

	# With devpts under Linux mounted properly, we do not need the pt_chown
	# binary to be setuid.  This is because the default owners/perms will be
	# exactly what we want.
	if in_iuse suid && ! use suid ; then
		find "${ED}" -name pt_chown -exec chmod -s {} +
	fi

	#################################################################
	# EVERYTHING AFTER THIS POINT IS FOR NATIVE GLIBC INSTALLS ONLY #
	# Make sure we install some symlink hacks so that when we build
	# a 2nd stage cross-compiler, gcc finds the target system
	# headers correctly.  See gcc/doc/gccinstall.info
	if is_crosscompile ; then
		# We need to make sure that /lib and /usr/lib always exists.
		# gcc likes to use relative paths to get to its multilibs like
		# /usr/lib/../lib64/.  So while we don't install any files into
		# /usr/lib/, we do need it to exist.
		cd "${ED}"$(alt_libdir)/..
		[[ -e lib ]] || mkdir lib
		cd "${ED}"$(alt_usrlibdir)/..
		[[ -e lib ]] || mkdir lib

		dosym usr/include $(alt_prefix)/sys-include
		return 0
	fi

	# Files for Debian-style locale updating
	dodir /usr/share/i18n
	sed \
		-e "/^#/d" \
		-e "/SUPPORTED-LOCALES=/d" \
		-e "s: \\\\::g" -e "s:/: :g" \
		"${S}"/localedata/SUPPORTED > "${ED}"/usr/share/i18n/SUPPORTED \
		|| die "generating /usr/share/i18n/SUPPORTED failed"
	cd "${WORKDIR}"/extra/locale
	dosbin locale-gen || die
	doman *.[0-8]
	insinto /etc
	doins locale.gen || die

	# Make sure all the ABI's can find the locales and so we only
	# have to generate one set
	local a
	keepdir /usr/$(get_libdir)/locale
	for a in $(get_install_abis) ; do
		if [[ ! -e ${ED}/usr/$(get_abi_LIBDIR ${a})/locale ]] ; then
			dosym /usr/$(get_libdir)/locale /usr/$(get_abi_LIBDIR ${a})/locale
		fi
	done

	cd "${S}"

	# Install misc network config files
	insinto /etc
	doins nscd/nscd.conf posix/gai.conf nss/nsswitch.conf || die
	doins "${WORKDIR}"/extra/etc/*.conf || die

	if ! in_iuse nscd || use nscd ; then
		doinitd "${WORKDIR}"/extra/etc/nscd || die

		local nscd_args=(
			-e "s:@PIDFILE@:$(strings "${ED}"/usr/sbin/nscd | grep nscd.pid):"
		)
		version_is_at_least 2.16 || nscd_args+=( -e 's: --foreground : :' )
		sed -i "${nscd_args[@]}" "${ED}"/etc/init.d/nscd

		# Newer versions of glibc include the nscd.service themselves.
		# TODO: Drop the $FILESDIR copy once 2.19 goes stable.
		if version_is_at_least 2.19 ; then
			systemd_dounit nscd/nscd.service || die
			systemd_newtmpfilesd nscd/nscd.tmpfiles nscd.conf || die
		else
			systemd_dounit "${FILESDIR}"/nscd.service || die
			systemd_newtmpfilesd "${FILESDIR}"/nscd.tmpfilesd nscd.conf || die
		fi
	else
		# Do this since extra/etc/*.conf above might have nscd.conf.
		rm -f "${ED}"/etc/nscd.conf
	fi

	echo 'LDPATH="include ld.so.conf.d/*.conf"' > "${T}"/00glibc
	doenvd "${T}"/00glibc || die

	for d in BUGS ChangeLog* CONFORMANCE FAQ NEWS NOTES PROJECTS README* ; do
		[[ -s ${d} ]] && dodoc ${d}
	done

	# Prevent overwriting of the /etc/localtime symlink.  We'll handle the
	# creation of the "factory" symlink in pkg_postinst().
	rm -f "${ED}"/etc/localtime
}

glibc_headers_install() {
	local builddir=$(builddir "headers")
	cd "${builddir}"
	emake install_root="${D}$(alt_prefix)" install-headers || die
	if ! version_is_at_least 2.16 ; then
		insinto $(alt_headers)/bits
		doins bits/stdio_lim.h || die
	fi
	insinto $(alt_headers)/gnu
	doins "${S}"/include/gnu/stubs.h || die "doins include gnu"
	# Make sure we install the sys-include symlink so that when
	# we build a 2nd stage cross-compiler, gcc finds the target
	# system headers correctly.  See gcc/doc/gccinstall.info
	dosym usr/include $(alt_prefix)/sys-include
}

src_install() {
	if just_headers ; then
		export ABI=default
		glibc_headers_install
		return
	fi

	foreach_abi glibc_do_src_install
	src_strip
}

pkg_preinst() {
	# nothing to do if just installing headers
	just_headers && return

	# prepare /etc/ld.so.conf.d/ for files
	mkdir -p "${EROOT}"/etc/ld.so.conf.d

	# Default /etc/hosts.conf:multi to on for systems with small dbs.
	if [[ $(wc -l < "${EROOT}"/etc/hosts) -lt 1000 ]] ; then
		sed -i '/^multi off/s:off:on:' "${ED}"/etc/host.conf
		elog "Defaulting /etc/host.conf:multi to on"
	fi

	[[ ${ROOT} != "/" ]] && return 0
	[[ -d ${ED}/$(get_libdir) ]] || return 0
	[[ -z ${BOOTSTRAP_RAP} ]] && glibc_sanity_check
}

pkg_postinst() {
	# nothing to do if just installing headers
	just_headers && return

	if ! tc-is-cross-compiler && [[ -x ${EROOT}/usr/sbin/iconvconfig ]] ; then
		# Generate fastloading iconv module configuration file.
		"${EROOT}"/usr/sbin/iconvconfig --prefix="${ROOT}"
	fi

	if ! is_crosscompile && [[ ${ROOT} == "/" ]] ; then
		# Reload init ... if in a chroot or a diff init package, ignore
		# errors from this step #253697
		/sbin/telinit U 2>/dev/null

		# if the host locales.gen contains no entries, we'll install everything
		local locale_list="${EROOT}etc/locale.gen"
		if [[ -z $(locale-gen --list --config "${locale_list}") ]] ; then
			ewarn "Generating all locales; edit /etc/locale.gen to save time/space"
			locale_list="${EROOT}usr/share/i18n/SUPPORTED"
		fi
		locale-gen -j $(makeopts_jobs) --config "${locale_list}"
	fi
}

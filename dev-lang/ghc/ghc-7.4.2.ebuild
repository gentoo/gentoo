# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Brief explanation of the bootstrap logic:
#
# Previous ghc ebuilds have been split into two: ghc and ghc-bin,
# where ghc-bin was primarily used for bootstrapping purposes.
# From now on, these two ebuilds have been combined, with the
# binary USE flag used to determine whether or not the pre-built
# binary package should be emerged or whether ghc should be compiled
# from source.  If the latter, then the relevant ghc-bin for the
# arch in question will be used in the working directory to compile
# ghc from source.
#
# This solution has the advantage of allowing us to retain the one
# ebuild for both packages, and thus phase out virtual/ghc.

# Note to users of hardened gcc-3.x:
#
# If you emerge ghc with hardened gcc it should work fine (because we
# turn off the hardened features that would otherwise break ghc).
# However, emerging ghc while using a vanilla gcc and then switching to
# hardened gcc (using gcc-config) will leave you with a broken ghc. To
# fix it you would need to either switch back to vanilla gcc or re-emerge
# ghc (or ghc-bin). Note that also if you are using hardened gcc-3.x and
# you switch to gcc-4.x that this will also break ghc and you'll need to
# re-emerge ghc (or ghc-bin). People using vanilla gcc can switch between
# gcc-3.x and 4.x with no problems.

EAPI="5"

inherit base autotools bash-completion-r1 eutils flag-o-matic multilib toolchain-funcs ghc-package versionator pax-utils

DESCRIPTION="The Glasgow Haskell Compiler"
HOMEPAGE="http://www.haskell.org/ghc/"

# we don't have any binaries yet
arch_binaries=""

# sorted!
arch_binaries="$arch_binaries alpha? ( http://code.haskell.org/~slyfox/ghc-alpha/ghc-bin-${PV}-alpha.tbz2 )"
#arch_binaries="$arch_binaries arm? ( http://code.haskell.org/~slyfox/ghc-arm/ghc-bin-${PV}-arm.tbz2 )"
arch_binaries="$arch_binaries amd64? ( http://code.haskell.org/~slyfox/ghc-amd64/ghc-bin-${PV}-amd64-stable-glibc.tbz2 )"
arch_binaries="$arch_binaries ia64?  ( http://code.haskell.org/~slyfox/ghc-ia64/ghc-bin-${PV}-ia64.tbz2 )"
arch_binaries="$arch_binaries ppc? ( http://code.haskell.org/~slyfox/ghc-ppc/ghc-bin-${PV}-ppc.tbz2 )"
arch_binaries="$arch_binaries ppc64? ( http://code.haskell.org/~slyfox/ghc-ppc64/ghc-bin-${PV}-ppc64.tbz2 )"
arch_binaries="$arch_binaries sparc? ( http://code.haskell.org/~slyfox/ghc-sparc/ghc-bin-${PV}-sparc.tbz2 )"
arch_binaries="$arch_binaries x86? ( http://code.haskell.org/~slyfox/ghc-x86/ghc-bin-${PV}-x86-stable-glibc.tbz2 )"

# various ports:
#arch_binaries="$arch_binaries x86-fbsd? ( http://code.haskell.org/~slyfox/ghc-x86-fbsd/ghc-bin-${PV}-x86-fbsd.tbz2 )"

# 0 - yet
yet_binary() {
	case "${ARCH}" in
		alpha) return 0 ;;
		#arm)
		#	ewarn "ARM binary is built on armv5tel-eabi toolchain. Use with caution."
		#	return 0
		#;;
		amd64) return 0 ;;
		ia64) return 0 ;;
		ppc) return 0 ;;
		ppc64) return 0 ;;
		sparc) return 0 ;;
		x86) return 0 ;;
		*) return 1 ;;
	esac
}

SRC_URI="!binary? ( http://www.haskell.org/ghc/dist/${PV}/${P}-src.tar.bz2 )"
[[ -n $arch_binaries ]] && SRC_URI+=" !ghcbootstrap? ( $arch_binaries )"
LICENSE="BSD"
SLOT="0/${PV}"
# ghc on ia64 needs gcc to support -mcmodel=medium (or some dark hackery) to avoid TOC overflow
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc ghcbootstrap ghcmakebinary +gmp llvm"
IUSE+=" binary" # don't forget about me later!
IUSE+=" elibc_glibc" # system stuff

RDEPEND="
	!kernel_Darwin? ( >=sys-devel/gcc-2.95.3 )
	kernel_linux? ( >=sys-devel/binutils-2.17 )
	kernel_SunOS? ( >=sys-devel/binutils-2.17 )
	>=dev-lang/perl-5.6.1
	>=dev-libs/gmp-5
	virtual/libffi
	!<dev-haskell/haddock-2.10.0
	sys-libs/ncurses[unicode]"
# earlier versions than 2.4.2 of haddock only works with older ghc releases

# force dependency on >=gmp-5, even if >=gmp-4.1 would be enough. this is due to
# that we want the binaries to use the latest versioun available, and not to be
# built against gmp-4

# similar for glibc. we have bootstrapped binaries against glibc-2.14
DEPEND="${RDEPEND}
	ghcbootstrap? (
		doc? ( app-text/docbook-xml-dtd:4.2
			app-text/docbook-xml-dtd:4.5
			app-text/docbook-xsl-stylesheets
			>=dev-libs/libxslt-1.1.2 ) )
	!ghcbootstrap? ( !prefix? ( elibc_glibc? ( >=sys-libs/glibc-2.14 ) ) )"

PDEPEND="!ghcbootstrap? ( =app-admin/haskell-updater-1.2* )"
PDEPEND="
	${PDEPEND}
	llvm? ( sys-devel/llvm )"

# ia64 fails to return from STG GMP primitives (stage2 always SIGSEGVs)
REQUIRED_USE="ia64? ( !gmp )"

append-ghc-cflags() {
	local flag compile assemble link
	for flag in $*; do
		case ${flag} in
			compile)	compile="yes";;
			assemble)	assemble="yes";;
			link)		link="yes";;
			*)
				[[ ${compile}  ]] && GHC_FLAGS="${GHC_FLAGS} -optc${flag}" CFLAGS="${CFLAGS} ${flag}"
				[[ ${assemble} ]] && GHC_FLAGS="${GHC_FLAGS} -opta${flag}" CFLAGS="${CFLAGS} ${flag}"
				[[ ${link}     ]] && GHC_FLAGS="${GHC_FLAGS} -optl${flag}" FILTERED_LDFLAGS="${FILTERED_LDFLAGS} ${flag}";;
		esac
	done
}

ghc_setup_cflags() {
	# We need to be very careful with the CFLAGS we ask ghc to pass through to
	# gcc. There are plenty of flags which will make gcc produce output that
	# breaks ghc in various ways. The main ones we want to pass through are
	# -mcpu / -march flags. These are important for arches like alpha & sparc.
	# We also use these CFLAGS for building the C parts of ghc, ie the rts.
	strip-flags
	strip-unsupported-flags

	# Cmm can't parse line numbers #482086
	replace-flags -ggdb[3-9] -ggdb2

	GHC_FLAGS=""
	for flag in ${CFLAGS}; do
		case ${flag} in

			# Ignore extra optimisation (ghc passes -O to gcc anyway)
			# -O2 and above break on too many systems
			-O*) ;;

			# Arch and ABI flags are what we're really after
			-m*) append-ghc-cflags compile assemble ${flag};;

			# Debugging flags don't help either. You can't debug Haskell code
			# at the C source level and the mangler discards the debug info.
			-g*) ;;

			# Ignore all other flags, including all -f* flags
		esac
	done

	FILTERED_LDFLAGS=""
	for flag in ${LDFLAGS}; do
		case ${flag} in
			# Pass the canary. we don't quite respect LDFLAGS, but we have an excuse!
			"-Wl,--hash-style="*) append-ghc-cflags link ${flag};;

			# Ignore all other flags
		esac
	done

	# hardened-gcc needs to be disabled, because the mangler doesn't accept
	# its output.
	gcc-specs-pie && append-ghc-cflags compile link	-nopie
	gcc-specs-ssp && append-ghc-cflags compile		-fno-stack-protector

	# prevent from failind building unregisterised ghc:
	# http://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg171602.html
	use ppc64 && append-ghc-cflags compile -mminimal-toc
	# fix the similar issue as ppc64 TOC on ia64. ia64 has limited size of small data
	# currently ghc fails to build haddock
	# http://osdir.com/ml/gnu.binutils.bugs/2004-10/msg00050.html
	use ia64 && append-ghc-cflags compile -G0

	# Unfortunately driver/split/ghc-split.lprl is dumb
	# enough to preserve stack marking for each split object
	# and it flags stack marking violation:
	# * !WX --- --- usr/lib64/ghc-7.4.1/base-4.5.0.0/libHSbase-4.5.0.0.a:Fingerprint__1.o
	# * !WX --- --- usr/lib64/ghc-7.4.1/base-4.5.0.0/libHSbase-4.5.0.0.a:Fingerprint__2.o
	# * !WX --- --- usr/lib64/ghc-7.4.1/base-4.5.0.0/libHSbase-4.5.0.0.a:Fingerprint__3.o
	case $($(tc-getAS) -v 2>&1 </dev/null) in
		*"GNU Binutils"*) # GNU ld
			append-ghc-cflags compile assemble -Wa,--noexecstack
			;;
	esac
}

# substitutes string $1 to $2 in files $3 $4 ...
relocate_path() {
	local from=$1
	local   to=$2
	shift 2
	local file=
	for file in "$@"
	do
		sed -i -e "s|$from|$to|g" \
			"$file" || die "path relocation failed for '$file'"
	done
}

# changes hardcoded ghc paths and updates package index
# $1 - new absolute root path
relocate_ghc() {
	local to=$1

	# backup original script to use it later after relocation
	local gp_back="${T}/ghc-pkg-${PV}-orig"
	cp "${WORKDIR}/usr/bin/ghc-pkg-${PV}" "$gp_back" || die "unable to backup ghc-pkg wrapper"

	# Relocate from /usr to ${EPREFIX}/usr
	relocate_path "/usr" "${to}/usr" \
		"${WORKDIR}/usr/bin/ghc-${PV}" \
		"${WORKDIR}/usr/bin/ghci-${PV}" \
		"${WORKDIR}/usr/bin/ghc-pkg-${PV}" \
		"${WORKDIR}/usr/bin/hsc2hs" \
		"${WORKDIR}/usr/$(get_libdir)/${P}/package.conf.d/"*

	# this one we will use to regenerate cache
	# so it shoult point to current tree location
	relocate_path "/usr" "${WORKDIR}/usr" "$gp_back"

	if use prefix; then
		# and insert LD_LIBRARY_PATH entry to EPREFIX dir tree
		# TODO: add the same for darwin's CHOST and it's DYLD_
		local new_ldpath='LD_LIBRARY_PATH="'${EPREFIX}/$(get_libdir):${EPREFIX}/usr/$(get_libdir)'${LD_LIBRARY_PATH:+:}${LD_LIBRARY_PATH}"\nexport LD_LIBRARY_PATH'
		sed -i -e '2i'"$new_ldpath" \
			"${WORKDIR}/usr/bin/ghc-${PV}" \
			"${WORKDIR}/usr/bin/ghci-${PV}" \
			"${WORKDIR}/usr/bin/ghc-pkg-${PV}" \
			"$gp_back" \
			"${WORKDIR}/usr/bin/hsc2hs" \
			|| die "Adding LD_LIBRARY_PATH for wrappers failed"
	fi

	# regenerate the binary package cache
	"$gp_back" recache || die "failed to update cache after relocation"
	rm "$gp_back"
}

pkg_setup() {
	# quiet portage about prebuilt binaries
	use binary && QA_PREBUILT="*"

	if use ghcbootstrap; then
		ewarn "You requested ghc bootstrapping, this is usually only used"
		ewarn "by Gentoo developers to make binary .tbz2 packages for"
		ewarn "use with the ghc ebuild's USE=\"binary\" feature."
		use binary && \
			die "USE=\"ghcbootstrap binary\" is not a valid combination."
		[[ -z $(type -P ghc) ]] && \
			die "Could not find a ghc to bootstrap with."
	else
		if ! yet_binary; then
			eerror "Please try emerging with USE=ghcbootstrap and report build"
			eerror "sucess or failure to the haskell team (haskell@gentoo.org)"
			die "No binary available for '${ARCH}' arch yet, USE=ghcbootstrap"
		fi
	fi
}

src_unpack() {
	# Create the ${S} dir if we're using the binary version
	use binary && mkdir "${S}"

	# the Solaris and Darwin binaries from ghc (maeder) need to be
	# unpacked separately, so prevent them from being unpacked
	local ONLYA=${A}
	case ${CHOST} in
		*-darwin* | *-solaris*)  ONLYA=${P}-src.tar.bz2  ;;
	esac
	unpack ${ONLYA}
}

src_prepare() {
	ghc_setup_cflags

	if ! use ghcbootstrap && [[ ${CHOST} != *-darwin* && ${CHOST} != *-solaris* ]]; then
		# Modify the wrapper script from the binary tarball to use GHC_FLAGS.
		# See bug #313635.
		sed -i -e "s|\"\$topdir\"|\"\$topdir\" ${GHC_FLAGS}|" \
			"${WORKDIR}/usr/bin/ghc-${PV}"

		# allow hardened users use vanilla binary to bootstrap ghc
		# ghci uses mmap with rwx protection at it implements dynamic
		# linking on it's own (bug #299709)
		pax-mark -m "${WORKDIR}/usr/$(get_libdir)/${P}/ghc"
	fi

	if use binary; then
		if use prefix; then
			relocate_ghc "${EPREFIX}"
		fi

		# Move unpacked files to the expected place
		mv "${WORKDIR}/usr" "${S}"
	else
		if ! use ghcbootstrap; then
			case ${CHOST} in
				*-darwin* | *-solaris*)
				mkdir "${WORKDIR}"/ghc-bin-installer || die
				pushd "${WORKDIR}"/ghc-bin-installer > /dev/null || die
				use sparc-solaris && unpack ghc-6.10.4-sparc-sun-solaris2.tar.bz2
				use x86-solaris && unpack ghc-7.0.3-i386-unknown-solaris2.tar.bz2
				use x86-macos && unpack ghc-7.4.1-i386-apple-darwin.tar.bz2
				use x64-macos && unpack ghc-7.4.1-x86_64-apple-darwin.tar.bz2
				popd > /dev/null

				pushd "${WORKDIR}"/ghc-bin-installer/ghc-[67].?*.? > /dev/null || die
				# fix the binaries so they run, on Solaris we need an
				# LD_LIBRARY_PATH which has our prefix libdirs, on
				# Darwin we need to replace the frameworks with our libs
				# from the prefix fix before installation, because some
				# of the tools are actually used during configure/make
				if [[ ${CHOST} == *-solaris* ]] ; then
					export LD_LIBRARY_PATH="${EPREFIX}/$(get_libdir):${EPREFIX}/usr/$(get_libdir):${LD_LIBRARY_PATH}"
				elif [[ ${CHOST} == *-darwin* ]] ; then
					local readline_framework=GNUreadline.framework/GNUreadline
					local gmp_framework=/opt/local/lib/libgmp.10.dylib
					local ncurses_file=/opt/local/lib/libncurses.5.dylib
					for binary in $(scanmacho -BRE MH_EXECUTE -F '%F' .) ; do
						install_name_tool -change \
							${readline_framework} \
							"${EPREFIX}"/lib/libreadline.dylib \
							${binary} || die
						install_name_tool -change \
							${gmp_framework} \
							"${EPREFIX}"/usr/lib/libgmp.dylib \
							${binary} || die
						install_name_tool -change \
							${ncurses_file} \
							"${EPREFIX}"/usr/lib/libncurses.dylib \
							${binary} || die
					done
					# we don't do frameworks!
					sed -i \
						-e 's/\(frameworks = \)\["GMP"\]/\1[]/g' \
						-e 's/\(extraLibraries = \)\["m"\]/\1["m","gmp"]/g' \
						rts/package.conf.in || die
				fi

				# it is autoconf, but we really don't want to give it too
				# much arguments, in fact we do the make in-place anyway
				./configure --prefix="${WORKDIR}"/usr || die
				make install || die
				popd > /dev/null
				;;
				*)
				relocate_ghc "${WORKDIR}"
				;;
			esac
		fi

		sed -i -e "s|\"\$topdir\"|\"\$topdir\" ${GHC_FLAGS}|" \
			"${S}/ghc/ghc.wrapper"

		cd "${S}" # otherwise epatch will break

		epatch "${FILESDIR}"/${PN}-7.0.4-CHOST-prefix.patch

		epatch "${FILESDIR}"/${PN}-7.0.4-darwin8.patch
		# failed to apply. FIXME
		#epatch "${FILESDIR}"/${PN}-6.12.3-mach-o-relocation-limit.patch

		epatch "${FILESDIR}"/${PN}-7.4-rc2-macos-prefix-respect-gcc.patch
		epatch "${FILESDIR}"/${PN}-7.4.1-darwin-CHOST.patch
		epatch "${FILESDIR}"/${PN}-7.2.1-freebsd-CHOST.patch

		we_want_libffi_workaround() {
			use ghcmakebinary && return 1

			# pick only registerised arches
			# https://bugs.gentoo.org/463814
			use amd64 && return 0
			use x86 && return 0
			return 1
		}
		# one mode external depend with unstable ABI be careful to stash it
		# avoid external libffi runtime when we build binaries
		we_want_libffi_workaround && epatch "${FILESDIR}"/${PN}-7.4.2-system-libffi.patch

		epatch "${FILESDIR}"/${PN}-7.4.1-ticket-7339-fix-unaligned-unreg.patch

		if use prefix; then
			# Make configure find docbook-xsl-stylesheets from Prefix
			sed -i -e '/^FP_DIR_DOCBOOK_XSL/s:\[.*\]:['"${EPREFIX}"'/usr/share/sgml/docbook/xsl-stylesheets/]:' utils/haddock/doc/configure.ac || die
		fi

		cd "${S}"/libraries/terminfo
		# bug #454216
		epatch "${FILESDIR}"/terminfo-0.3.2.5-tinfo.patch

		cd "${S}"
		# as we have changed the build system
		eautoreconf
	fi
}

src_configure() {
	if ! use binary; then

		# initialize build.mk
		echo '# Gentoo changes' > mk/build.mk

		# Put docs into the right place, ie /usr/share/doc/ghc-${PV}
		echo "docdir = ${EPREFIX}/usr/share/doc/${P}" >> mk/build.mk
		echo "htmldir = ${EPREFIX}/usr/share/doc/${P}" >> mk/build.mk

		# We also need to use the GHC_FLAGS flags when building ghc itself
		echo "SRC_HC_OPTS+=${GHC_FLAGS}" >> mk/build.mk
		echo "SRC_CC_OPTS+=${CFLAGS}" >> mk/build.mk
		echo "SRC_LD_OPTS+=${FILTERED_LDFLAGS}" >> mk/build.mk

		# We can't depend on haddock except when bootstrapping when we
		# must build docs and include them into the binary .tbz2 package
		if use ghcbootstrap && use doc; then
			echo "BUILD_DOCBOOK_PDF  = NO"  >> mk/build.mk
			echo "BUILD_DOCBOOK_PS   = NO"  >> mk/build.mk
			echo "BUILD_DOCBOOK_HTML = YES" >> mk/build.mk
			echo "HADDOCK_DOCS       = YES" >> mk/build.mk
		else
			echo "BUILD_DOCBOOK_PDF  = NO" >> mk/build.mk
			echo "BUILD_DOCBOOK_PS   = NO" >> mk/build.mk
			echo "BUILD_DOCBOOK_HTML = NO" >> mk/build.mk
			echo "HADDOCK_DOCS       = NO" >> mk/build.mk
		fi

		# circumvent a very strange bug that seems related with ghc producing
		# too much output while being filtered through tee (e.g. due to
		# portage logging) reported as bug #111183
		echo "SRC_HC_OPTS+=-w" >> mk/build.mk

		# some arches do not support ELF parsing for ghci module loading
		# PPC64: never worked (should be easy to implement)
		# alpha: never worked
		# arm: unimplemented or never worked
		if use alpha || use ppc64 || use arm; then
			echo "GhcWithInterpreter=NO" >> mk/build.mk
		fi

		# we have to tell it to build unregisterised on some arches
		# ppc64: EvilMangler currently does not understand some TOCs
		# ia64: EvilMangler bitrot
		if use alpha || use ia64 || use ppc64; then
			echo "GhcUnregisterised=YES" >> mk/build.mk
			echo "GhcWithNativeCodeGen=NO" >> mk/build.mk
			echo "SplitObjs=NO" >> mk/build.mk
			echo "GhcRTSWays := debug" >> mk/build.mk
			echo "GhcNotThreaded=YES" >> mk/build.mk
		fi

		# arm: no EvilMangler support, no NCG support
		if use arm; then
			echo "GhcUnregisterised=YES" >> mk/build.mk
			echo "GhcWithNativeCodeGen=NO" >> mk/build.mk
		fi

		# Have "ld -r --relax" problem with split-objs on sparc:
		if use sparc; then
			echo "SplitObjs=NO" >> mk/build.mk
		fi

		if ! use llvm; then
			echo "GhcWithLlvmCodeGen=NO" >> mk/build.mk
		fi

		# allows overriding build flavours for libraries:
		# v   - vanilla (static libs)
		# p   - profiled
		# dyn - shared libraries
		# example: GHC_LIBRARY_WAYS="v dyn"
		if [[ -n ${GHC_LIBRARY_WAYS} ]]; then
			echo "GhcLibWays=${GHC_LIBRARY_WAYS}" >> mk/build.mk
		fi

		# Get ghc from the unpacked binary .tbz2
		# except when bootstrapping we just pick ghc up off the path
		if ! use ghcbootstrap; then
			export PATH="${WORKDIR}/usr/bin:${PATH}"
		fi

		if use gmp; then
			echo "INTEGER_LIBRARY=integer-gmp" >> mk/build.mk
		else
			echo "INTEGER_LIBRARY=integer-simple" >> mk/build.mk
		fi

		# Since GHC 6.12.2 the GHC wrappers store which GCC version GHC was
		# compiled with, by saving the path to it. The purpose is to make sure
		# that GHC will use the very same gcc version when it compiles haskell
		# sources, as the extra-gcc-opts files contains extra gcc options which
		# match only this GCC version.
		# However, this is not required in Gentoo, as only modern GCCs are used
		# (>4).
		# Instead, this causes trouble when for example ccache is used during
		# compilation, but we don't want the wrappers to point to ccache.
		# Due to the above, we simply set GCC to be "gcc". When compiling ghc it
		# might point to ccache, once installed it will point to the users
		# regular gcc.

		econf --with-gcc=gcc || die "econf failed"
	fi # ! use binary
}

src_compile() {
	if ! use binary; then
		limit_jobs() {
			if [[ -n ${I_DEMAND_MY_CORES_LOADED} ]]; then
				ewarn "You have requested parallel build which is known to break."
				ewarn "Please report all breakages upstream."
				return
			fi
			echo $@
		}
		# ghc massively parallel make: #409631, #409873
		#   but let users screw it by setting 'I_DEMAND_MY_CORES_LOADED'
		emake $(limit_jobs -j1) all
	fi # ! use binary
}

src_install() {
	if use binary; then
		use prefix && mkdir -p "${ED}"
		mv "${S}/usr" "${ED}"

		# Remove the docs if not requested
		if ! use doc; then
			rm -rf "${ED}/usr/share/doc/${P}/*/" \
				"${ED}/usr/share/doc/${P}/*.html" \
				|| die "could not remove docs (P vs PF revision mismatch?)"
		fi
	else
		local insttarget="install"

		# We only built docs if we were bootstrapping, otherwise
		# we copy them out of the unpacked binary .tbz2
		if use doc && ! use ghcbootstrap; then
			mkdir -p "${ED}/usr/share/doc"
			mv "${WORKDIR}/usr/share/doc/${P}" "${ED}/usr/share/doc" \
				|| die "failed to copy docs"
		else
			dodoc "${S}/README" "${S}/ANNOUNCE" "${S}/LICENSE" "${S}/VERSION"
		fi

		emake -j1 ${insttarget} \
			DESTDIR="${D}" \
			|| die "make ${insttarget} failed"

		# remove wrapper and linker
		rm -f "${ED}"/usr/bin/haddock*

		# ghci uses mmap with rwx protection at it implements dynamic
		# linking on it's own (bug #299709)
		# so mark resulting binary
		pax-mark -m "${ED}/usr/$(get_libdir)/${P}/ghc"

		dobashcomp "${FILESDIR}/ghc-bash-completion"

	fi

	# path to the package.cache
	local package_confdir="${ED}/usr/$(get_libdir)/${P}/package.conf.d"
	PKGCACHE="${package_confdir}"/package.cache

	cp -pR "${package_confdir}"{,.initial} || die "failed to backup intial package.conf.d"

	# copy the package.conf, including timestamp, save it so we later can put it
	# back before uninstalling, or when upgrading.
	cp -p "${PKGCACHE}"{,.shipped} \
		|| die "failed to copy package.conf.d/package.cache"
}

pkg_preinst() {
	# have we got an earlier version of ghc installed?
	if has_version "<${CATEGORY}/${PF}"; then
		haskell_updater_warn="1"
	fi
}

pkg_postinst() {
	ghc-reregister

	# path to the package.cache
	PKGCACHE="${EROOT}/usr/$(get_libdir)/${P}/package.conf.d/package.cache"

	# give the cache a new timestamp, it must be as recent as
	# the package.conf.d directory.
	touch "${PKGCACHE}"

	if [[ "${haskell_updater_warn}" == "1" ]]; then
		ewarn
		ewarn "\e[1;31m************************************************************************\e[0m"
		ewarn
		ewarn "You have just upgraded from an older version of GHC."
		ewarn "You may have to run"
		ewarn "      'haskell-updater --upgrade'"
		ewarn "to rebuild all ghc-based Haskell libraries."
		ewarn
		ewarn "\e[1;31m************************************************************************\e[0m"
		ewarn
	fi
}

pkg_prerm() {
	# Be very careful here... Call order when upgrading is (according to PMS):
	# * src_install for new package
	# * pkg_preinst for new package
	# * pkg_postinst for new package
	# * pkg_prerm for the package being replaced
	# * pkg_postrm for the package being replaced
	# so you'll actually be touching the new packages files, not the one you
	# uninstall, due to that or installation directory ${P} will be the same for
	# both packages.

	# Call order for reinstalling is (according to PMS):
	# * src_install
	# * pkg_preinst
	# * pkg_prerm for the package being replaced
	# * pkg_postrm for the package being replaced
	# * pkg_postinst

	# Overwrite the modified package.cache with a copy of the
	# original one, so that it will be removed during uninstall.

	PKGCACHE="${EROOT}/usr/$(get_libdir)/${P}/package.conf.d/package.cache"
	rm -rf "${PKGCACHE}"

	cp -p "${PKGCACHE}"{.shipped,}
}

pkg_postrm() {
	ghc-package_pkg_postrm
}

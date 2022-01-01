# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# to make make a crosscompiler use crossdev and symlink ghc tree into
# cross overlay. result would look like 'cross-sparc-unknown-linux-gnu/ghc'
#
# 'CTARGET' definition and 'is_crosscompile' are taken from 'toolchain.eclass'
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} = ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

inherit autotools bash-completion-r1 eutils flag-o-matic ghc-package
inherit multilib pax-utils toolchain-funcs versionator prefix

DESCRIPTION="The Glasgow Haskell Compiler"
HOMEPAGE="https://www.haskell.org/ghc/"

# we don't have any binaries yet
arch_binaries=""

# sorted!
arch_binaries="$arch_binaries alpha? ( https://slyfox.uni.cx/~slyfox/distfiles/ghc-bin-${PV}-alpha.tbz2 )"
#arch_binaries="$arch_binaries arm? ( https://slyfox.uni.cx/~slyfox/distfiles/ghc-bin-${PV}-arm.tbz2 )"
arch_binaries="$arch_binaries amd64? ( https://slyfox.uni.cx/~slyfox/distfiles/ghc-bin-${PVR}-amd64.tbz2 )"
arch_binaries="$arch_binaries ia64?  ( https://slyfox.uni.cx/~slyfox/distfiles/ghc-bin-${PV}-ia64.tbz2 )"
arch_binaries="$arch_binaries ppc? ( https://slyfox.uni.cx/~slyfox/distfiles/ghc-bin-${PV}-ppc.tbz2 )"
arch_binaries="$arch_binaries ppc64? ( https://slyfox.uni.cx/~slyfox/distfiles/ghc-bin-${PV}-ppc64.tbz2 )"
arch_binaries="$arch_binaries sparc? ( https://slyfox.uni.cx/~slyfox/distfiles/ghc-bin-${PV}-sparc.tbz2 )"
arch_binaries="$arch_binaries x86? ( https://slyfox.uni.cx/~slyfox/distfiles/ghc-bin-${PVR}-x86.tbz2 )"

# various ports:
#arch_binaries="$arch_binaries x86-fbsd? ( https://slyfox.uni.cx/~slyfox/distfiles/ghc-bin-${PV}-x86-fbsd.tbz2 )"

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

GHC_PV=${PV}
#GHC_PV=7.10.2.20151030 # uncomment only for -rc ebuilds
GHC_P=${PN}-${GHC_PV} # using ${P} is almost never correct

SRC_URI="!binary? ( https://downloads.haskell.org/~ghc/${PV/_rc/-rc}/${GHC_P}-src.tar.bz2 )"
S="${WORKDIR}"/${GHC_P}

[[ -n $arch_binaries ]] && SRC_URI+=" !ghcbootstrap? ( $arch_binaries )"

BUMP_LIBRARIES=(
	# "hackage-name          hackage-version"
	"binary                  0.7.6.1"
	"hoopl                   3.10.2.0"
	"transformers            0.4.3.0"
)

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc ghcbootstrap ghcmakebinary +gmp"
IUSE+=" binary"
IUSE+=" elibc_glibc" # system stuff

RDEPEND="
	>=dev-lang/perl-5.6.1
	>=dev-libs/gmp-5:=
	sys-libs/ncurses:0=[unicode]
	!ghcmakebinary? ( dev-libs/libffi:= )
"

# This set of dependencies is needed to run
# prebuilt ghc. We specifically avoid ncurses
# dependency with:
#    utils/ghc-pkg_HC_OPTS += -DBOOTSTRAPPING
PREBUILT_BINARY_DEPENDS="
	!prefix? ( elibc_glibc? ( >=sys-libs/glibc-2.17 ) )
"
# This set of dependencies is needed to install
# ghc[binary] in system. terminfo package is linked
# against ncurses.
PREBUILT_BINARY_RDEPENDS="${PREBUILT_BINARY_DEPENDS}
	sys-libs/ncurses-compat:5
"

RDEPEND+="binary? ( ${PREBUILT_BINARY_RDEPENDS} )"

DEPEND="${RDEPEND}
	doc? ( app-text/docbook-xml-dtd:4.2
		app-text/docbook-xml-dtd:4.5
		app-text/docbook-xsl-stylesheets
		>=dev-libs/libxslt-1.1.2 )
	!ghcbootstrap? ( ${PREBUILT_BINARY_DEPENDS} )"

PDEPEND="!ghcbootstrap? ( =app-admin/haskell-updater-1.2* )"

REQUIRED_USE="?? ( ghcbootstrap binary )"

# haskell libraries built with cabal in configure mode, #515354
QA_CONFIGURE_OPTIONS+=" --with-compiler --with-gcc"

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

# returns tool prefix for crosscompiler.
# Example:
#  CTARGET=armv7a-unknown-linux-gnueabi
#  CHOST=x86_64-pc-linux-gnu
#    "armv7a-unknown-linux-gnueabi-"
#  CTARGET=${CHOST}
#    ""
# Used in tools and library prefix:
#    "${ED}"/usr/bin/$(cross)haddock
#    "${ED}/usr/$(get_libdir)/$(cross)${GHC_P}/package.conf.d"

cross() {
	if is_crosscompile; then
		echo "${CTARGET}-"
	else
		echo ""
	fi
}

append-ghc-cflags() {
	local persistent compile assemble link
	local flag ghcflag

	for flag in $*; do
		case ${flag} in
			persistent)	persistent="yes";;
			compile)	compile="yes";;
			assemble)	assemble="yes";;
			link)		link="yes";;
			*)
				[[ ${compile}  ]] && ghcflag="-optc${flag}"  CFLAGS+=" ${flag}" && GHC_FLAGS+=" ${ghcflag}" &&
					[[ ${persistent} ]] && GHC_PERSISTENT_FLAGS+=" ${ghcflag}"
				[[ ${assemble} ]] && ghcflag="-opta${flag}"  CFLAGS+=" ${flag}" && GHC_FLAGS+=" ${ghcflag}" &&
					[[ ${persistent} ]] && GHC_PERSISTENT_FLAGS+=" ${ghcflag}"
				[[ ${link}     ]] && ghcflag="-optl${flag}" LDFLAGS+=" ${flag}" && GHC_FLAGS+=" ${ghcflag}" &&
					[[ ${persistent} ]] && GHC_PERSISTENT_FLAGS+=" ${ghcflag}"
				;;
		esac
	done
}

# $1 - lib name (under libraries/)
# $2 - lib version
# example: bump_lib "transformers" "0.4.2.0"
bump_lib() {
	local pn=$1 pv=$2
	local p=${pn}-${pv}
	local f

	einfo "Bumping ${pn} up to ${pv}"

	for f in ghc.mk GNUmakefile; do
		mv libraries/"${pn}"/$f "${WORKDIR}"/"${p}"/$f || die
	done
	mv libraries/"${pn}" "${WORKDIR}"/"${pn}".old || die
	mv "${WORKDIR}"/"${p}" libraries/"${pn}" || die
}

update_SRC_URI() {
	local p pn pv
	for p in "${BUMP_LIBRARIES[@]}"; do
		set -- $p
		pn=$1 pv=$2

		SRC_URI+=" https://hackage.haskell.org/package/${pn}-${pv}/${pn}-${pv}.tar.gz"
	done
}

update_SRC_URI

bump_libs() {
	local p pn pv
	for p in "${BUMP_LIBRARIES[@]}"; do
		set -- $p
		pn=$1 pv=$2

		bump_lib "${pn}" "${pv}"
	done
}

ghc_setup_cflags() {
	if is_crosscompile; then
		export CFLAGS=${GHC_CFLAGS-"-O2 -pipe"}
		export LDFLAGS=${GHC_LDFLAGS-"-Wl,-O1"}
		einfo "Crosscompiling mode:"
		einfo "   CHOST:   ${CHOST}"
		einfo "   CTARGET: ${CTARGET}"
		einfo "   CFLAGS:  ${CFLAGS}"
		einfo "   LDFLAGS: ${LDFLAGS}"
		einfo "   prefix: $(cross)"
		return
	fi
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
	GHC_PERSISTENT_FLAGS=""
	for flag in ${CFLAGS}; do
		case ${flag} in

			# Ignore extra optimisation (ghc passes -O to gcc anyway)
			# -O2 and above break on too many systems
			-O*) ;;

			# Arch and ABI flags are what we're really after
			-m*) append-ghc-cflags compile assemble ${flag};;

			# Sometimes it's handy to see backtrace of RTS
			# to get an idea what happens there
			-g*) append-ghc-cflags compile ${flag};;

			# Ignore all other flags, including all -f* flags
		esac
	done

	for flag in ${LDFLAGS}; do
		append-ghc-cflags link ${flag}
	done

	# hardened-gcc needs to be disabled, because our prebuilt binaries/libraries
	# are not built with fPIC, bug #606666
	gcc-specs-pie && append-ghc-cflags persistent compile link -nopie
	tc-is-gcc && version_is_at_least 6.3 $(gcc-version) && if ! use ghcbootstrap; then
		# gcc-6.3 has support for -no-pie upstream, but spelling differs from
		# gentoo-specific '-nopie'. We enable it in non-bootstrap to allow
		# hardened users try '-pie' in USE=ghcbootstrap mode.
		append-ghc-cflags compile link -no-pie
	fi
	gcc-specs-ssp && append-ghc-cflags persistent compile      -fno-stack-protector

	# prevent from failind building unregisterised ghc:
	# https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg171602.html
	use ppc64 && append-ghc-cflags persistent compile -mminimal-toc
	# fix the similar issue as ppc64 TOC on ia64. ia64 has limited size of small data
	# currently ghc fails to build haddock
	# https://osdir.com/ml/gnu.binutils.bugs/2004-10/msg00050.html
	use ia64 && append-ghc-cflags persistent compile -G0
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

	# libdir for prebuilt binary and for current system may mismatch
	# It does for prefix installation for example: bug #476998
	local bin_ghc_prefix=${WORKDIR}/usr
	local bin_libpath=$(echo "${bin_ghc_prefix}"/lib*)
	local bin_libdir=${bin_libpath#${bin_ghc_prefix}/}

	# backup original script to use it later after relocation
	local gp_back="${T}/ghc-pkg-${GHC_PV}-orig"
	cp "${WORKDIR}/usr/bin/$(cross)ghc-pkg-${GHC_PV}" "$gp_back" || die "unable to backup ghc-pkg wrapper"

	if [[ ${bin_libdir} != $(get_libdir) ]]; then
		einfo "Relocating '${bin_libdir}' to '$(get_libdir)' (bug #476998)"
		# moving the dir itself is not strictly needed
		# but then USE=binary would result in installing
		# in '${bin_libdir}'
		mv "${bin_ghc_prefix}/${bin_libdir}" "${bin_ghc_prefix}/$(get_libdir)" || die

		relocate_path "/usr/${bin_libdir}" "/usr/$(get_libdir)" \
			"${WORKDIR}/usr/bin/$(cross)ghc-${GHC_PV}" \
			"${WORKDIR}/usr/bin/$(cross)ghci-${GHC_PV}" \
			"${WORKDIR}/usr/bin/$(cross)ghc-pkg-${GHC_PV}" \
			"${WORKDIR}/usr/bin/$(cross)hsc2hs" \
			"${WORKDIR}/usr/bin/$(cross)runghc-${GHC_PV}" \
			"$gp_back" \
			"${WORKDIR}/usr/$(get_libdir)/$(cross)${GHC_P}/package.conf.d/"*
	fi

	# Relocate from /usr to ${EPREFIX}/usr
	relocate_path "/usr" "${to}/usr" \
		"${WORKDIR}/usr/bin/$(cross)ghc-${GHC_PV}" \
		"${WORKDIR}/usr/bin/$(cross)ghci-${GHC_PV}" \
		"${WORKDIR}/usr/bin/$(cross)ghc-pkg-${GHC_PV}" \
		"${WORKDIR}/usr/bin/$(cross)hsc2hs" \
		"${WORKDIR}/usr/bin/$(cross)runghc-${GHC_PV}" \
		"${WORKDIR}/usr/$(get_libdir)/$(cross)${GHC_P}/package.conf.d/"*

	# this one we will use to regenerate cache
	# so it should point to current tree location
	relocate_path "/usr" "${WORKDIR}/usr" "$gp_back"

	if use prefix; then
		hprefixify "${bin_libpath}"/${PN}*/settings
	fi

	# regenerate the binary package cache
	"$gp_back" recache || die "failed to update cache after relocation"
	rm "$gp_back"
}

pkg_setup() {
	# quiet portage about prebuilt binaries
	use binary && QA_PREBUILT="*"

	[[ ${MERGE_TYPE} == binary ]] && return

	if use ghcbootstrap; then
		ewarn "You requested ghc bootstrapping, this is usually only used"
		ewarn "by Gentoo developers to make binary .tbz2 packages."

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
		*-darwin* | *-solaris*)  ONLYA=${GHC_P}-src.tar.bz2  ;;
	esac
	unpack ${ONLYA}

	if [[ -d "${S}"/libraries/dph ]]; then
		# Sometimes dph libs get accidentally shipped with ghc
		# but they are not installed unless user requests it.
		# We never install them.
		elog "Removing 'libraries/dph'"
		rm -rf "${S}"/libraries/dph
	fi
}

src_prepare() {
	ghc_setup_cflags

	if ! use ghcbootstrap && [[ ${CHOST} != *-darwin* && ${CHOST} != *-solaris* ]]; then
		# Modify the wrapper script from the binary tarball to use GHC_PERSISTENT_FLAGS.
		# See bug #313635.
		sed -i -e "s|\"\$topdir\"|\"\$topdir\" ${GHC_PERSISTENT_FLAGS}|" \
			"${WORKDIR}/usr/bin/$(cross)ghc-${GHC_PV}"

		# allow hardened users use vanilla binary to bootstrap ghc
		# ghci uses mmap with rwx protection at it implements dynamic
		# linking on it's own (bug #299709)
		pax-mark -m "${WORKDIR}/usr/$(get_libdir)/$(cross)${GHC_P}/bin/ghc"
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
				# UPDATE ME for ghc-7
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

		sed -i -e "s|\"\$topdir\"|\"\$topdir\" ${GHC_PERSISTENT_FLAGS}|" \
			"${S}/ghc/ghc.wrapper"

		cd "${S}" # otherwise epatch will break

		epatch "${FILESDIR}"/${PN}-7.0.4-CHOST-prefix.patch

		epatch "${FILESDIR}"/${PN}-7.8.2-cgen-constify.patch
		epatch "${FILESDIR}"/${PN}-7.8.3-prim-lm.patch
		epatch "${FILESDIR}"/${PN}-7.10.1-rc3-ghc-7.10-bootstrap.patch
		epatch "${FILESDIR}"/${PN}-7.10.3-relnotes.patch
		epatch "${FILESDIR}"/${PN}-7.10.3-hardfloat.patch

		# Since ${S}/packages does not include base, etc. add them to gen_contents_index
		sed -e 's@\(for REPO in .*\)@\1 base integer-gmp integer-gmp2 integer-simple template-haskell@' \
			-i libraries/gen_contents_index || die

		if use prefix; then
			# Make configure find docbook-xsl-stylesheets from Prefix
			sed -e '/^FP_DIR_DOCBOOK_XSL/s:\[.*\]:['"${EPREFIX}"'/usr/share/sgml/docbook/xsl-stylesheets/]:' \
				-i utils/haddock/doc/configure.ac || die
		fi

		bump_libs

		# as we have changed the build system
		eautoreconf
	fi
}

src_configure() {
	if ! use binary; then
		# initialize build.mk
		echo '# Gentoo changes' > mk/build.mk

		# Put docs into the right place, ie /usr/share/doc/ghc-${GHC_PV}
		echo "docdir = ${EPREFIX}/usr/share/doc/${P}" >> mk/build.mk
		echo "htmldir = ${EPREFIX}/usr/share/doc/${P}" >> mk/build.mk

		# We also need to use the GHC_FLAGS flags when building ghc itself
		echo "SRC_HC_OPTS+=${HCFLAGS} ${GHC_FLAGS}" >> mk/build.mk
		echo "SRC_CC_OPTS+=${CFLAGS}" >> mk/build.mk
		echo "SRC_LD_OPTS+=${LDFLAGS}" >> mk/build.mk

		# We can't depend on haddock except when bootstrapping when we
		# must build docs and include them into the binary .tbz2 package
		# app-text/dblatex is not in portage, can not build PDF or PS
		echo "BUILD_DOCBOOK_PDF  = NO"  >> mk/build.mk
		echo "BUILD_DOCBOOK_PS   = NO"  >> mk/build.mk
		if use doc; then
			echo "BUILD_DOCBOOK_HTML = YES" >> mk/build.mk
		else
			echo "BUILD_DOCBOOK_HTML = NO" >> mk/build.mk
		fi

		# this controls presence on 'xhtml' and 'haddock' in final install
		echo "HADDOCK_DOCS       = YES" >> mk/build.mk

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
			echo "INTEGER_LIBRARY=integer-gmp2" >> mk/build.mk
		else
			echo "INTEGER_LIBRARY=integer-simple" >> mk/build.mk
		fi

		# don't strip anything. Very useful when stage2 SIGSEGVs on you
		echo "STRIP_CMD = :" >> mk/build.mk

		local econf_args=()

		# GHC embeds 'gcc' it was built by and uses it later.
		# Don't allow things like ccache or versioned binary slip.
		# We use stable thing across gcc upgrades.
		is_crosscompile || econf_args+=(--with-gcc=${CHOST}-gcc)

		if use ghcmakebinary; then
			# When building booting libary we are trying to
			# bundle or restrict most of external depends
			# with unstable ABI:
			#  - embed libffi (default GHC behaviour)
			#  - disable ncurses support for ghci (via haskeline)
			#    https://bugs.gentoo.org/557478
			#  - disable ncurses support for ghc-pkg
			echo "libraries/haskeline_CONFIGURE_OPTS += --flag=-terminfo" >> mk/build.mk
			echo "utils/ghc-pkg_HC_OPTS += -DBOOTSTRAPPING" >> mk/build.mk
		else
			econf_args+=(--with-system-libffi)
			econf_args+=(--with-ffi-includes=$($(tc-getPKG_CONFIG) libffi --cflags-only-I | sed -e 's@^-I@@'))
		fi

		elog "Final mk/build.mk:"
		cat mk/build.mk || die

		econf ${econf_args[@]} --enable-bootstrap-with-devel-snapshot

		if [[ ${PV} == *9999* ]]; then
			GHC_PV="$(grep 'S\[\"PACKAGE_VERSION\"\]' config.status | sed -e 's@^.*=\"\(.*\)\"@\1@')"
			GHC_P=${PN}-${GHC_PV}
		fi
	fi # ! use binary
}

src_compile() {
	if ! use binary; then
		# 1. build compiler binary first
		emake ghc/stage2/build/tmp/ghc-stage2
		# 2. pax-mark (bug #516430)
		pax-mark -m ghc/stage2/build/tmp/ghc-stage2
		# 3. and then all the rest
		emake all
	fi # ! use binary
}

src_install() {
	if use binary; then
		use prefix && mkdir -p "${ED}"
		mv "${S}/usr" "${ED}"
	else

		emake -j1 install DESTDIR="${D}"
		dodoc "distrib/README" "ANNOUNCE" "LICENSE" "VERSION"

		# rename ghc-shipped files to avoid collision
		# of external packages. Motivating example:
		#  user had installed:
		#      dev-lang/ghc-7.8.4-r0 (with transformers-0.3.0.0)
		#      dev-haskell/transformers-0.4.2.0
		#  then user tried to update to
		#      dev-lang/ghc-7.8.4-r1 (with transformers-0.4.2.0)
		#  this will lead to single .conf file collision.
		local shipped_conf renamed_conf
		local package_confdir="${ED}/usr/$(get_libdir)/$(cross)${GHC_P}/package.conf.d"
		for shipped_conf in "${package_confdir}"/*.conf; do
			# rename 'pkg-ver-id.conf' to 'pkg-ver-id-gentoo-${PF}.conf'
			renamed_conf=${shipped_conf%.conf}-gentoo-${PF}.conf
			mv "${shipped_conf}" "${renamed_conf}" || die
		done

		# remove link, but leave 'haddock-${GHC_P}'
		rm -f "${ED}"/usr/bin/$(cross)haddock

		if [[ ! -f "${S}/VERSION" ]]; then
			echo "${GHC_PV}" > "${S}/VERSION" \
				|| die "Could not create file ${S}/VERSION"
		fi
		if ! is_crosscompile; then
			newbashcomp "${FILESDIR}"/ghc-bash-completion ghc-pkg
			newbashcomp utils/completion/ghc.bash         ghc
		fi
	fi

	# path to the package.cache
	local package_confdir="${ED}/usr/$(get_libdir)/$(cross)${GHC_P}/package.conf.d"
	PKGCACHE="${package_confdir}"/package.cache
	# copy the package.conf.d, including timestamp, save it so we can help
	# users that have a broken package.conf.d
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
	PKGCACHE="${EROOT}/usr/$(get_libdir)/$(cross)${GHC_P}/package.conf.d/package.cache"

	# give the cache a new timestamp, it must be as recent as
	# the package.conf.d directory.
	touch "${PKGCACHE}"

	if [[ "${haskell_updater_warn}" == "1" ]]; then
		ewarn
		ewarn "\e[1;31m************************************************************************\e[0m"
		ewarn
		ewarn "You have just upgraded from an older version of GHC."
		ewarn "You may have to run"
		ewarn "      'haskell-updater'"
		ewarn "to rebuild all ghc-based Haskell libraries."
		ewarn
		ewarn "\e[1;31m************************************************************************\e[0m"
		ewarn
	fi
}

pkg_prerm() {
	PKGCACHE="${EROOT}/usr/$(get_libdir)/$(cross)${GHC_P}/package.conf.d/package.cache"
	rm -rf "${PKGCACHE}"

	cp -p "${PKGCACHE}"{.shipped,}
}

pkg_postrm() {
	ghc-package_pkg_postrm
}

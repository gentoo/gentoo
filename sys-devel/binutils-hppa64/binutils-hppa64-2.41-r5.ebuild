# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

export CTARGET=hppa64-${CHOST#*-}

inherit libtool flag-o-matic gnuconfig multilib strip-linguas toolchain-funcs

DESCRIPTION="Tools necessary to build programs"
HOMEPAGE="https://sourceware.org/binutils/"

LICENSE="GPL-3+"
IUSE="cet default-gold doc gold gprofng multitarget +nls pgo +plugins static-libs test vanilla"
REQUIRED_USE="default-gold? ( gold )"

# Variables that can be set here  (ignored for live ebuilds)
# PATCH_VER          - the patchset version
#                      Default: empty, no patching
# PATCH_BINUTILS_VER - the binutils version in the patchset name
#                    - Default: PV
# PATCH_DEV          - Use download URI https://dev.gentoo.org/~{PATCH_DEV}/distfiles/...
#                      for the patchsets

PATCH_VER=5
PATCH_DEV=dilfridge

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	SLOT=${PV}
else
	PATCH_BINUTILS_VER=${PATCH_BINUTILS_VER:-${PV}}
	PATCH_DEV=${PATCH_DEV:-dilfridge}
	SRC_URI="mirror://gnu/binutils/binutils-${PV}.tar.xz https://dev.gentoo.org/~${PATCH_DEV}/distfiles/binutils-${PV}.tar.xz"
	[[ -z ${PATCH_VER} ]] || SRC_URI="${SRC_URI}
		https://dev.gentoo.org/~${PATCH_DEV}/distfiles/binutils-${PATCH_BINUTILS_VER}-patches-${PATCH_VER}.tar.xz"
	SLOT=$(ver_cut 1-2)
	KEYWORDS="-* hppa"
fi

#
# The cross-compile logic
#
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }

#
# The dependencies
#
RDEPEND="
	>=sys-devel/binutils-config-3
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( sys-apps/texinfo )
	test? (
		dev-util/dejagnu
		app-alternatives/bc
	)
	nls? ( sys-devel/gettext )
	app-alternatives/lex
	app-alternatives/yacc
"

RESTRICT="!test? ( test )"

MY_BUILDDIR="${WORKDIR}"/build
S="${WORKDIR}"/${P/-hppa64/}

src_unpack() {
	if [[ ${PV} == 9999* ]] ; then
		EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/toolchain/binutils-patches.git"
		EGIT_CHECKOUT_DIR="${WORKDIR}"/patches-git
		git-r3_src_unpack
		mv patches-git/9999 patch || die

		S="${WORKDIR}"/binutils
		EGIT_REPO_URI="https://sourceware.org/git/binutils-gdb.git"
		EGIT_CHECKOUT_DIR="${S}"
		git-r3_src_unpack
	else
		unpack ${P/-hppa64/}.tar.xz

		cd "${WORKDIR}" || die
		unpack binutils-${PATCH_BINUTILS_VER}-patches-${PATCH_VER}.tar.xz

		# _p patch versions are Gentoo specific tarballs ...
		local dir=${P%_p?}
		dir=${dir/-hppa64/}

		S=${WORKDIR}/${dir}
	fi

	cd "${WORKDIR}" || die
	mkdir -p "${MY_BUILDDIR}" || die
}

src_prepare() {
	local patchsetname
	if [[ ${PV} == 9999* ]] ; then
		patchsetname="from git master"
	else
		patchsetname="${PATCH_BINUTILS_VER}-${PATCH_VER}"
	fi

	if [[ -n ${PATCH_VER} ]] || [[ ${PV} == 9999* ]] ; then
		if ! use vanilla; then
			einfo "Applying binutils patchset ${patchsetname}"
			eapply "${WORKDIR}/patch"
			einfo "Done."
		fi
	fi

	# Make sure our explicit libdir paths don't get clobbered, bug #562460
	sed -i \
		-e 's:@bfdlibdir@:@libdir@:g' \
		-e 's:@bfdincludedir@:@includedir@:g' \
		{bfd,opcodes}/Makefile.in || die

	# Apply things from PATCHES and user dirs
	default

	# Run misc portage update scripts
	gnuconfig_update
	elibtoolize --portage --no-uclibc
}

toolchain-binutils_bugurl() {
	printf "https://bugs.gentoo.org/"
}
toolchain-binutils_pkgversion() {
	printf "Gentoo ${PV}"
	[[ -n ${PATCH_VER} ]] && printf " p${PATCH_VER}"
}

src_configure() {
	# See https://www.gnu.org/software/make/manual/html_node/Parallel-Output.html
	# Avoid really confusing logs from subconfigure spam, makes logs far
	# more legible.
	MAKEOPTS="--output-sync=line ${MAKEOPTS}"

	# Setup some paths
	LIBPATH=/usr/$(get_libdir)/binutils/${CTARGET}/${PV}
	INCPATH=${LIBPATH}/include
	DATAPATH=/usr/share/binutils-data/${CTARGET}/${PV}
	if is_cross ; then
		TOOLPATH=/usr/${CHOST}/${CTARGET}
	else
		TOOLPATH=/usr/${CTARGET}
	fi
	BINPATH=${TOOLPATH}/binutils-bin/${PV}

	# Make sure we filter $LINGUAS so that only ones that
	# actually work make it through, bug #42033
	strip-linguas -u */po

	# Keep things sane
	strip-flags

	use elibc_musl && append-ldflags -Wl,-z,stack-size=2097152

	local x
	echo
	for x in CATEGORY CBUILD CHOST CTARGET CFLAGS LDFLAGS ; do
		einfo "$(printf '%10s' ${x}:) ${!x}"
	done
	echo

	cd "${MY_BUILDDIR}" || die
	local myconf=()

	if use plugins ; then
		myconf+=( --enable-plugins )
	fi
	# enable gold (installed as ld.gold) and ld's plugin architecture
	if use gold ; then
		myconf+=( --enable-gold )
		if use default-gold; then
			myconf+=( --enable-gold=default )
		fi
	fi

	if use nls ; then
		myconf+=( --without-included-gettext )
	else
		myconf+=( --disable-nls )
	fi

	myconf+=( --with-system-zlib )

	# For bi-arch systems, enable a 64bit bfd. This matches the bi-arch
	# logic in toolchain.eclass. bug #446946
	#
	# We used to do it for everyone, but it's slow on 32bit arches. bug #438522
	case $(tc-arch) in
		ppc|sparc|x86) myconf+=( --enable-64-bit-bfd ) ;;
	esac

	use multitarget && myconf+=( --enable-targets=all --enable-64-bit-bfd )

	[[ -n ${CBUILD} ]] && myconf+=( --build=${CBUILD} )

	is_cross && myconf+=(
		--with-sysroot="${EPREFIX}"/usr/${CTARGET}
		--enable-poison-system-directories
	)

	myconf+=( --enable-secureplt )

	# mips can't do hash-style=gnu ...
	if [[ $(tc-arch) != mips ]] ; then
		myconf+=( --enable-default-hash-style=gnu )
	fi

	myconf+=(
		--prefix="${EPREFIX}"/usr
		--host=${CHOST}
		--target=${CTARGET}
		--datadir="${EPREFIX}"${DATAPATH}
		--datarootdir="${EPREFIX}"${DATAPATH}
		--infodir="${EPREFIX}"${DATAPATH}/info
		--mandir="${EPREFIX}"${DATAPATH}/man
		--bindir="${EPREFIX}"${BINPATH}
		--libdir="${EPREFIX}"${LIBPATH}
		--libexecdir="${EPREFIX}"${LIBPATH}
		--includedir="${EPREFIX}"${INCPATH}
		# portage's econf() does not detect presence of --d-d-t
		# because it greps only top-level ./configure. But not
		# libiberty's or bfd's configure.
		--disable-dependency-tracking
		--disable-silent-rules
		--enable-obsolete
		--enable-shared
		--enable-threads
		# Newer versions (>=2.27) offer a configure flag now.
		--enable-relro
		# Newer versions (>=2.24) make this an explicit option, bug #497268
		--enable-install-libiberty
		# Available from 2.35 on
		--enable-textrel-check=warning

		# These hardening options are available from 2.39+ but
		# they unconditionally enable the behaviour even on arches
		# where e.g. execstacks can't be avoided.
		# See https://sourceware.org/bugzilla/show_bug.cgi?id=29592.
		#--enable-warn-execstack
		#--enable-warn-rwx-segments
		#--disable-default-execstack (or is it --enable-default-execstack=no? docs are confusing)

		# Things to think about
		#--enable-deterministic-archives

		# Works better than vapier's patch, bug #808787
		--enable-new-dtags

		--disable-jansson
		--disable-werror
		--with-bugurl="$(toolchain-binutils_bugurl)"
		--with-pkgversion="$(toolchain-binutils_pkgversion)"
		$(use_enable static-libs static)
		# Disable modules that are in a combined binutils/gdb tree, bug #490566
		--disable-{gdb,libdecnumber,readline,sim}
		# Strip out broken static link flags.
		# https://gcc.gnu.org/PR56750
		--without-stage1-ldflags
		# Change SONAME to avoid conflict across
		# {native,cross}/binutils, binutils-libs. bug #666100
		--with-extra-soversion-suffix=gentoo-${CATEGORY}-${PN}-$(usex multitarget mt st)

		# Avoid automagic dependency on (currently prefix) systems
		# systems with debuginfod library, bug #754753
		--without-debuginfod

		# Avoid automagic dev-libs/msgpack dep, bug #865875
		--without-msgpack

		# Allow user to opt into CET for host libraries.
		# Ideally we would like automagic-or-disabled here.
		# But the check does not quite work on i686: bug #760926.
		$(use_enable cet)

		# We can enable this by default in future, but it's brand new
		# in 2.39 with several bugs:
		# - Doesn't build on musl (https://sourceware.org/bugzilla/show_bug.cgi?id=29477)
		# - No man pages (https://sourceware.org/bugzilla/show_bug.cgi?id=29521)
		# - Broken at runtime without Java (https://sourceware.org/bugzilla/show_bug.cgi?id=29479)
		# - binutils-config (and this ebuild?) needs adaptation first (https://bugs.gentoo.org/865113)
		$(use_enable gprofng)
	)

	if ! is_cross ; then
		# No LTO for HPPA64 right now as we don't build kgcc64 with LTO support.
		myconf+=( $(use_enable pgo pgo-build) )

		if use pgo ; then
			export BUILD_CFLAGS="${CFLAGS}"
		fi
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"

	# Prevent makeinfo from running if doc is unset.
	if ! use doc ; then
		sed -i \
			-e '/^MAKEINFO/s:=.*:= true:' \
			Makefile || die
	fi
}

src_compile() {
	cd "${MY_BUILDDIR}" || die

	# see Note [tooldir hack for ldscripts]
	emake tooldir="${EPREFIX}${TOOLPATH}" all

	# only build info pages if the user wants them
	if use doc ; then
		emake info
	fi

	# we nuke the manpages when we're left with junk
	# (like when we bootstrap, no perl -> no manpages)
	find . -name '*.1' -a -size 0 -delete
}

src_test() {
	cd "${MY_BUILDDIR}" || die

	# bug #637066
	filter-flags -Wall -Wreturn-type

	emake -k check
}

src_install() {
	local x d

	cd "${MY_BUILDDIR}" || die

	# see Note [tooldir hack for ldscripts]
	emake DESTDIR="${D}" tooldir="${EPREFIX}${LIBPATH}" install
	rm -rf "${ED}"/${LIBPATH}/bin || die
	use static-libs || find "${ED}" -name '*.la' -delete

	# Newer versions of binutils get fancy with ${LIBPATH}, bug #171905
	cd "${ED}"/${LIBPATH} || die
	for d in ../* ; do
		[[ ${d} == ../${PV} ]] && continue
		mv ${d}/* . || die
		rmdir ${d} || die
	done

	# Now we collect everything intp the proper SLOT-ed dirs
	# When something is built to cross-compile, it installs into
	# /usr/$CHOST/ by default ... we have to 'fix' that :)
	if is_cross ; then
		cd "${ED}"/${BINPATH} || die
		for x in * ; do
			mv ${x} ${x/${CTARGET}-} || die
		done

		if [[ -d ${ED}/usr/${CHOST}/${CTARGET} ]] ; then
			# No die for now, dies on hppa?
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
	doins "${libiberty_headers[@]/#/${S}/include/}"
	if [[ -d ${ED}/${LIBPATH}/lib ]] ; then
		# TODO: add || die here, fails on hppa?
		mv "${ED}"/${LIBPATH}/lib/* "${ED}"/${LIBPATH}/
		rm -r "${ED}"/${LIBPATH}/lib
	fi

	# Generate an env.d entry for this binutils
	insinto /etc/env.d/binutils
	cat <<-EOF > "${T}"/env.d
		TARGET="${CTARGET}"
		VER="${PV}"
		LIBPATH="${EPREFIX}${LIBPATH}"
	EOF
	newins "${T}"/env.d ${CTARGET}-${PV}

	# Handle documentation
	if ! is_cross ; then
		cd "${S}" || die
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
	rm -f "${ED}"/${DATAPATH}/info/{dir,configure.info,standards.info} || die

	# Trim all empty dirs
	find "${ED}" -depth -type d -exec rmdir {} + 2>/dev/null

	# the hppa64 hack; this should go into 9999 as a PN-conditional
	# tweak the default fake list a little bit
	cd "${D}"/etc/env.d/binutils
	sed -i '/FAKE_TARGETS=/s:"$: hppa64-linux":' ${CTARGET}-${PV} || die
}

pkg_postinst() {
	# Make sure this ${CTARGET} has a binutils version selected
	[[ -e ${EROOT}/etc/env.d/binutils/config-${CTARGET} ]] && return 0
	binutils-config ${CTARGET}-${PV}
}

pkg_postrm() {
	local current_profile=$(binutils-config -c ${CTARGET})

	# If no other versions exist, then uninstall for this
	# target ... otherwise, switch to the newest version
	# Note: only do this if this version is unmerged.  We
	#       rerun binutils-config if this is a remerge, as
	#       we want the mtimes on the symlinks updated (if
	#       it is the same as the current selected profile)
	if [[ ! -e ${EPREFIX}${BINPATH}/ld ]] && [[ ${current_profile} == ${CTARGET}-${PV} ]] ; then
		local choice=$(binutils-config -l | grep ${CTARGET} | awk '{print $2}')
		choice=${choice//$'\n'/ }
		choice=${choice/* }
		if [[ -z ${choice} ]] ; then
			binutils-config -u ${CTARGET}
		else
			binutils-config ${choice}
		fi
	elif [[ $(CHOST=${CTARGET} binutils-config -c) == ${CTARGET}-${PV} ]] ; then
		binutils-config ${CTARGET}-${PV}
	fi
}

# Note [slotting support]
# -----------------------
# Gentoo's layout for binutils files is non-standard as Gentoo
# supports slotted installation for binutils. Many tools
# still expect binutils to reside in known locations.
# binutils-config package restores symlinks into known locations,
# like:
#    /usr/bin/${CTARGET}-<tool>
#    /usr/bin/${CHOST}/${CTARGET}/lib/ldscrips
#    /usr/include/
#
# Note [tooldir hack for ldscripts]
# ---------------------------------
# Build system does not allow ./configure to tweak every location
# we need for slotting binutils hence all the shuffling in
# src_install(). This note is about SCRIPTDIR define handling.
#
# SCRIPTDIR defines 'ldscripts/' directory location. SCRIPTDIR value
# is set at build-time in ld/Makefile.am as: 'scriptdir = $(tooldir)/lib'
# and hardcoded as -DSCRIPTDIR='"$(scriptdir)"' at compile time.
# Thus we can't just move files around after compilation finished.
#
# Our goal is the following:
# - at build-time set scriptdir to point to symlinked location:
#   ${TOOLPATH}: /usr/${CHOST} (or /usr/${CHOST}/${CTARGET} for cross-case)
# - at install-time set scriptdir to point to slotted location:
#   ${LIBPATH}: /usr/$(get_libdir)/binutils/${CTARGET}/${PV}

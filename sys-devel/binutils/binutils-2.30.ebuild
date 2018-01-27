# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils libtool flag-o-matic gnuconfig multilib versionator

DESCRIPTION="Tools necessary to build programs"
HOMEPAGE="https://sourceware.org/binutils/"
LICENSE="GPL-3+"
IUSE="+cxx doc multitarget +nls static-libs test"

# Variables that can be set here:
# PATCH_VER          - the patchset version
#                      Default: empty, no patching
# PATCH_BINUTILS_VER - the binutils version in the patchset name
#                    - Default: PV
# PATCH_DEV          - Use download URI https://dev.gentoo.org/~{PATCH_DEV}/distfiles/...
#                      for the patchsets
#                      Default: dilfridge :)

PATCH_VER=1

case ${PV} in
	9999)
		BVER="git"
		EGIT_REPO_URI="https://sourceware.org/git/binutils-gdb.git"
		inherit git-r3
		S=${WORKDIR}/binutils
		EGIT_CHECKOUT_DIR=${S}
		;;
	*)
		BVER=${PV}
		SRC_URI="mirror://gnu/binutils/binutils-${BVER}.tar.xz https://sourceware.org/pub/binutils/releases/binutils-${BVER}.tar.xz"
		;;
esac
SLOT="${BVER}"
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"

#
# The Gentoo patchset
#
PATCH_BINUTILS_VER=${PATCH_BINUTILS_VER:-${BVER}}
PATCH_DEV=${PATCH_DEV:-dilfridge}

[[ -z ${PATCH_VER} ]] || SRC_URI="${SRC_URI}
	https://dev.gentoo.org/~${PATCH_DEV}/distfiles/binutils-${PATCH_BINUTILS_VER}-patches-${PATCH_VER}.tar.xz"

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
DEPEND="${RDEPEND}
	doc? ( sys-apps/texinfo )
	test? ( dev-util/dejagnu )
	nls? ( sys-devel/gettext )
	sys-devel/flex
	virtual/yacc
"
if is_cross ; then
	# The build assumes the host has libiberty and such when cross-compiling
	# its build tools.  We should probably make binutils itself build a local
	# copy to use, but until then, be lazy.
	DEPEND+=" >=sys-libs/binutils-libs-${PV}"
fi

MY_BUILDDIR=${WORKDIR}/build

src_unpack() {
	case ${PV} in
		9999)
			git-r3_src_unpack;
			;;
		*)
			default
			;;
	esac
	mkdir -p "${MY_BUILDDIR}"
}

src_prepare() {
	if [[ ! -z ${PATCH_VER} ]] ; then
		einfo "Applying binutils-${PATCH_BINUTILS_VER} patchset ${PATCH_VER}"
		eapply "${WORKDIR}/patch"/*.patch
	fi

	# This check should probably go somewhere else, like pkg_pretend.
	if [[ ${CTARGET} == *-uclibc* ]] ; then
		if grep -qs 'linux-gnu' "${S}"/ltconfig ; then
			die "sorry, but this binutils doesn't yet support uClibc :("
		fi
	fi

	# Make sure our explicit libdir paths don't get clobbered. #562460
	sed -i \
		-e 's:@bfdlibdir@:@libdir@:g' \
		-e 's:@bfdincludedir@:@includedir@:g' \
		{bfd,opcodes}/Makefile.in || die

	# Fix locale issues if possible #122216
	if [[ -e ${FILESDIR}/binutils-configure-LANG.patch ]] ; then
		einfo "Fixing misc issues in configure files"
		for f in $(find "${S}" -name configure -exec grep -l 'autoconf version 2.13' {} +) ; do
			ebegin "  Updating ${f/${S}\/}"
			patch "${f}" "${FILESDIR}"/binutils-configure-LANG.patch >& "${T}"/configure-patch.log \
				|| eerror "Please file a bug about this"
			eend $?
		done
	fi

	# Fix conflicts with newer glibc #272594
	if [[ -e libiberty/testsuite/test-demangle.c ]] ; then
		sed -i 's:\<getline\>:get_line:g' libiberty/testsuite/test-demangle.c
	fi

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
	printf "Gentoo ${BVER}"
	[[ -n ${PATCH_VER} ]] && printf " p${PATCH_VER}"
}

src_configure() {
	# Setup some paths
	LIBPATH=/usr/$(get_libdir)/binutils/${CTARGET}/${BVER}
	INCPATH=${LIBPATH}/include
	DATAPATH=/usr/share/binutils-data/${CTARGET}/${BVER}
	if is_cross ; then
		BINPATH=/usr/${CHOST}/${CTARGET}/binutils-bin/${BVER}
	else
		BINPATH=/usr/${CTARGET}/binutils-bin/${BVER}
	fi

	# Make sure we filter $LINGUAS so that only ones that
	# actually work make it through #42033
	strip-linguas -u */po

	# Keep things sane
	strip-flags

	local x
	echo
	for x in CATEGORY CBUILD CHOST CTARGET CFLAGS LDFLAGS ; do
		einfo "$(printf '%10s' ${x}:) ${!x}"
	done
	echo

	cd "${MY_BUILDDIR}"
	local myconf=()

	# enable gold (installed as ld.gold) and ld's plugin architecture
	if use cxx ; then
		myconf+=( --enable-gold )
		myconf+=( --enable-plugins )
	fi

	if use nls ; then
		myconf+=( --without-included-gettext )
	else
		myconf+=( --disable-nls )
	fi

	myconf+=( --with-system-zlib )

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
		--enable-obsolete
		--enable-shared
		--enable-threads
		# Newer versions (>=2.27) offer a configure flag now.
		--enable-relro
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

	# Prevent makeinfo from running if doc is unset.
	if ! use doc ; then
		sed -i \
			-e '/^MAKEINFO/s:=.*:= true:' \
			Makefile || die
	fi
}

src_compile() {
	cd "${MY_BUILDDIR}"
	emake all

	# only build info pages if the user wants them
	if use doc ; then
		emake info
	fi

	# we nuke the manpages when we're left with junk
	# (like when we bootstrap, no perl -> no manpages)
	find . -name '*.1' -a -size 0 -delete
}

src_test() {
	cd "${MY_BUILDDIR}"
	emake -k check
}

src_install() {
	local x d

	cd "${MY_BUILDDIR}"
	emake DESTDIR="${D}" tooldir="${EPREFIX}${LIBPATH}" install
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

pkg_postinst() {
	# Make sure this ${CTARGET} has a binutils version selected
	[[ -e ${EROOT}/etc/env.d/binutils/config-${CTARGET} ]] && return 0
	binutils-config ${CTARGET}-${BVER}
}

pkg_postrm() {
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

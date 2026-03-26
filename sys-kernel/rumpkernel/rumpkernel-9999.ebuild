# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: check for any automagic dependencies, possible USE flags
# TODO: make building natively work

inherit flag-o-matic multiprocessing toolchain-funcs

DESCRIPTION="NetBSD's rumpkernel for the Hurd"
HOMEPAGE="https://salsa.debian.org/hurd-team/rumpkernel https://darnassus.sceen.net/~hurd-web/hurd/rump/ https://rumpkernel.github.io/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://salsa.debian.org/hurd-team/rumpkernel.git"
	inherit git-r3
elif [[ ${PV} == *_pre*_p* ]] ; then
	# These are proper Debian relaeses. rumpkernel isn't currently
	# part of the Debian archive, so this is the best we can do (no
	# 'orig' tarballs).
	RUMPKERNEL_PV=0_$(ver_cut 3)-$(ver_cut 5)

	SRC_URI="https://salsa.debian.org/hurd-team/rumpkernel/-/archive/debian/${RUMPKERNEL_PV}/rumpkernel-debian-${RUMPKERNEL_PV}.tar.bz2"
	S="${WORKDIR}"/${PN}-debian-${RUMPKERNEL_PV}
else
	# Snapshots
	RUMPKERNEL_COMMIT="c65c4413295247f3390385fb623215d3bd8d6052"
	SRC_URI="https://salsa.debian.org/hurd-team/rumpkernel/-/archive/${RUMPKERNEL_COMMIT}/rumpkernel-${RUMPKERNEL_COMMIT}.tar.bz2"
fi

# A lot from NetBSD, see:
# https://salsa.debian.org/hurd-team/rumpkernel/-/blob/master/debian/copyright
LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 BSD-4 CDDL GPL-1 GPL-2+ GPL-3+ ISC
	LGPL-2.1+ MIT public-domain ZLIB"

SLOT="0"
if [[ ${PV} != *9999* ]] ; then
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	x11-libs/libpciaccess
	virtual/zlib:=
"
DEPEND="
	${RDEPEND}
	dev-util/mig
	sys-kernel/gnumach
"

PATCHES=(
	"${FILESDIR}"/${PN}-0_p20250111_p6-bsd-own-mk-no-sysroot.patch
)

src_prepare() {
	default

	eapply $(sed -e 's:^:debian/patches/:' debian/patches/series || die)
}

src_configure() {
	# TODO: conflict with -pg but we might not need -pg to begin with;
	# objects get built thrice (regular, -pg, -fPIC).
	filter-flags -fomit-frame-pointer

	export HOST_CC=$(tc-getBUILD_CC)
	export HOST_CPPFLAGS=-D_GNU_SOURCE
	export TARGET_AR=${CHOST}-ar
	export TARGET_CC=${CHOST}-gcc
	export TARGET_CXX=${CHOST}-g++
	export TARGET_LD=${CHOST}-ld
	export TARGET_MIG=${CHOST}-mig
	export TARGET_NM=${CHOST}-nm
	export MIG=${CHOST}-mig
	export _GCC_CRTENDS= _GCC_CRTEND= _GCC_CRTBEGINS= _GCC_CRTBEGIN= _GCC_CRTI= _GCC_CRTN=
	export BSDOBJDIR="${S}"/obj

	cd buildrump.sh/src/lib/librumpuser || die "Couldn't change to the build directory"
	econf

	case ${CHOST} in
		i[3-7]86*)
			NBARCH=i386
			;;
		x86_64*)
			NBARCH=amd64
			;;
		*)
			die "Unknown NetBSD arch for this CHOST"
			;;
	esac
	NBMAKE="${S}"/buildrump.sh/src/obj/tooldir/bin/nbmake-${NBARCH}
}

src_compile() {
	cd buildrump.sh/src || die "Couldn't change to the build directory"
	mkdir -p obj || die "Couldn't make obj dir"

	local buildrump_cppflags=(
		-I"${S}"/buildrump.sh/src/obj/destdir.${NBARCH}/usr/include

		-D_FILE_OFFSET_BITS=64
		-DRUMP_REGISTER_T=int
		-DRUMPUSER_CONFIG=yes
		-DNO_PCI_MSI_MSIX=yes
		-DNUSB_DMA=1
		-DPAE
		-DBUFPAGES=16

		# Workaround broken open() call
		-U_FORTIFY_SOURCE

		# libipsec doesn't get CWARNFLAGS, apparently
		-Wno-error=unused-but-set-variable
	)

	local buildrump_warnflags=(
		-Wno-error=unused-but-set-variable
		-Wno-error=maybe-uninitialized
		-Wno-error=address-of-packed-member
		-Wno-error=unused-variable
		-Wno-error=stack-protector
		-Wno-error=array-parameter
		-Wno-error=array-bounds
		-Wno-error=stringop-overflow
		-Wno-error=int-to-pointer-cast
		-Wno-error=incompatible-pointer-types
		-Wno-error=unterminated-string-initialization
		-Wno-error=format-nonliteral
		-Wno-error=sign-compare
	)

	local mybuildshargs=(
		-V TOOLS_BUILDRUMP=yes
		-V MKBINUTILS=no
		-V MKGDB=no
		-V MKGROFF=no
		-V MKDTRACE=no
		-V MKZFS=no

		-V TOPRUMP="${S}"/buildrump.sh/src/sys/rump
		-V BUILDRUMP_CPPFLAGS="-Wno-error=stringop-overread"
		-V RUMPUSER_EXTERNAL_DPLIBS=pthread

		-V CPPFLAGS="${buildrump_cppflags[*]}"
		-V CWARNFLAGS="${buildrump_warnflags[*]}"
		#-V TARGET_LDADD="-Wl,-v -v"

		-V _GCC_CRTENDS="" -V _GCC_CRTEND=""
		-V _GCC_CRTBEGINS="" -V _GCC_CRTBEGIN=""
		-V _GCC_CRTI="" -V _GCC_CRTN=""
		-V MIG=${CHOST}-mig

		-m ${NBARCH}
		-U -u
		-j $(get_makeopts_jobs)
		-T ./obj/tooldir
	)

	# The Makefiles scattered across NetBSD use $S everywhere. So we
	# will get rid of this. Otherwise, you won't see some things build
	# in the correct directory. Thank you sam
	(
		_S="${S}"
		unset S

		ebegin "Building tools + rumpkernel"
		./build.sh "${mybuildshargs[@]}" tools rump
		eend $? || die "rumpkernel's ./build.sh failed"

		cd "${_S}"/buildrump.sh/src/lib/librumpuser || die "couldn't cd"
		ebegin "Building librumpuser"
		RUMPRUN=true ${NBMAKE} -j$(get_makeopts_jobs) MIG=${CHOST}-mig dependall
		eend $? || die "librumpuser build failed"

		cd "${_S}"/pci-userspace/src-gnu || die "couldn't cd"
		ebegin "Building pci-userspace"
		${NBMAKE} -j$(get_makeopts_jobs) MIG=${CHOST}-mig dependall
		eend $? || die "pci-userspace build failed"
	)
}

src_install() {
	dodir /usr/include /usr/$(get_libdir)

	# Install logic copied from Debian
	cp -a "${S}"/buildrump.sh/src/sys/rump/include/rump "${ED}"/usr/include/ || die
	# Kept "${S}"/buildrump.sh/src/obj separate here as may change to
	# another builddir.
	find "${S}"/buildrump.sh/src "${S}"/buildrump.sh/src/obj -type f,l \
		-name "librump*.so*" -exec cp -a {} "${ED}"/usr/$(get_libdir)/ \; || die
	find "${S}"/buildrump.sh/src "${S}"/buildrump.sh/src/obj -type f \
		-name "librump*.a" -exec cp -a {} "${ED}"/usr/$(get_libdir)/ \; || die

	# rempve non lib files
	rm -f "${ED}"/usr/$(get_libdir)/*.map || die
	#
	rm -f "${ED}"/usr/$(get_libdir)/librumpkern_z.* || die
}

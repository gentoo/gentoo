# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-2"
	EGIT_REPO_URI="https://github.com/lu-zero/postproc.git"
fi

inherit eutils flag-o-matic multilib multilib-minimal toolchain-funcs ${SCM}

DESCRIPTION="Video post processing library"
HOMEPAGE="https://github.com/lu-zero/postproc"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
elif [ "${PV%_p*}" != "${PV}" ] ; then # Snapshot
	SRC_URI="mirror://gentoo/${P}.tar.xz"
else # Release
	SRC_URI="https://dev.gentoo.org/~lu_zero/distfiles/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"
if [ "${PV#9999}" = "${PV}" ] ; then
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
fi
IUSE="pic static-libs"

# String for CPU features in the useflag[:configure_option] form
# if :configure_option isn't set, it will use 'useflag' as configure option
CPU_FEATURES="cpu_flags_x86_3dnow:amd3dnow altivec cpu_flags_x86_mmx:mmx cpu_flags_x86_mmxext:mmxext"
for i in ${CPU_FEATURES}; do
	IUSE="${IUSE} ${i%:*}"
done

RDEPEND="
	>=media-video/libav-0.8.2-r2:0=
	!media-video/ffmpeg:0"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-support-MMXEXT.patch
}

multilib_src_configure() {
	local myconf=( ${EXTRA_LIBPOSTPROC_CONF} )
	for i in $(get-flag march) $(get-flag mcpu) $(get-flag mtune) ; do
		[[ "${i}" = "native" ]] && i="host" # bug #273421
		myconf+=( --cpu=${i} )
		break
	done

	if use pic ; then
		myconf+=( --enable-pic )
		# disable asm code if PIC is required
		# as the provided asm decidedly is not PIC for x86.
		[[ ${ABI} == x86 ]] && myconf+=( --disable-asm )
	fi

	# cross compile support
	if tc-is-cross-compiler ; then
		myconf+=( --enable-cross-compile --arch=$(tc-arch-kernel) --cross-prefix=${CHOST}- )
		case ${CHOST} in
			*freebsd*)
				myconf+=( --target-os=freebsd )
				;;
			mingw32*)
				myconf+=( --target-os=mingw32 )
				;;
			*linux*)
				myconf+=( --target-os=linux )
				;;
		esac
	fi

	"${S}"/configure \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--shlibdir="${EPREFIX}/usr/$(get_libdir)" \
		--enable-shared \
		--cc="$(tc-getCC)" \
		--ar="$(tc-getAR)" \
		--optflags="${CFLAGS}" \
		--extra-cflags="${CFLAGS}" \
		$(use_enable static-libs static) \
		"${myconf[@]}" || die
}

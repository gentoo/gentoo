# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools libtool multilib-minimal toolchain-funcs

DESCRIPTION="High-quality and portable font engine"
HOMEPAGE="https://www.freetype.org/"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/wernerlemberg.asc
	inherit verify-sig
	SRC_URI="
		https://downloads.sourceforge.net/freetype/${P/_/}.tar.xz
		mirror://nongnu/freetype/${P/_/}.tar.xz
		utils? (
			https://downloads.sourceforge.net/freetype/ft2demos-${PV}.tar.xz
			mirror://nongnu/freetype/ft2demos-${PV}.tar.xz
			verify-sig? (
				https://downloads.sourceforge.net/freetype/ft2demos-${PV}.tar.xz.sig
				mirror://nongnu/freetype/ft2demos-${PV}.tar.xz.sig
			)
		)
		doc? (
			https://downloads.sourceforge.net/freetype/${PN}-doc-${PV}.tar.xz
			mirror://nongnu/freetype/${PN}-doc-${PV}.tar.xz
			verify-sig? (
				https://downloads.sourceforge.net/freetype/${PN}-doc-${PV}.tar.xz.sig
				mirror://nongnu/freetype/${PN}-doc-${PV}.tar.xz.sig
			)
		)
		verify-sig? (
			https://downloads.sourceforge.net/freetype/${P/_/}.tar.xz.sig
			mirror://nongnu/freetype/${P/_/}.tar.xz.sig
		)
	"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-wernerlemberg )"
fi

LICENSE="|| ( FTL GPL-2+ )"
SLOT="2"
IUSE="X +adobe-cff brotli bzip2 +cleartype-hinting debug doc fontforge harfbuzz +png static-libs svg utils"

RDEPEND="
	>=virtual/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	brotli? ( app-arch/brotli[${MULTILIB_USEDEP}] )
	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.2.51:=[${MULTILIB_USEDEP}] )
	utils? (
		svg? ( >=gnome-base/librsvg-2.46.0[${MULTILIB_USEDEP}] )
		X? ( >=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${RDEPEND}"
BDEPEND+="
	virtual/pkgconfig
"
PDEPEND="harfbuzz? ( >=media-libs/harfbuzz-1.3.0[truetype,${MULTILIB_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${P}-deref-check.patch
	"${FILESDIR}"/${P}-ubsan-overflow.patch
)

_egit_repo_handler() {
	if [[ ${PV} == 9999 ]] ; then
		local phase="${1}"
		case ${phase} in
			fetch|unpack)
				:;
			;;
			*)
				die "Please use this function with either \"fetch\" or \"unpack\""
			;;
		esac

		local EGIT_REPO_URI
		EGIT_REPO_URI="https://gitlab.freedesktop.org/freetype/freetype.git"
		git-r3_src_${phase}
		if use utils ; then
			EGIT_REPO_URI="https://gitlab.freedesktop.org/freetype/freetype-demos.git"
			local EGIT_CHECKOUT_DIR="${WORKDIR}/ft2demos-${PV}"
			git-r3_src_${phase}
		fi
	else
		default

		if use verify-sig; then
			verify-sig_verify_detached "${DISTDIR}"/${P}.tar.xz{,.sig}

			use doc && verify-sig_verify_detached "${DISTDIR}"/${PN}-doc-${PV}.tar.xz{,.sig}
			use utils && verify-sig_verify_detached "${DISTDIR}"/ft2demos-${PV}.tar.xz{,.sig}
		fi
	fi
}

pkg_pretend() {
	if use svg && ! use utils ; then
		einfo "The \"svg\" USE flag only has effect when the \"utils\" USE flag is also enabled."
	fi
}

src_unpack() {
	_egit_repo_handler ${EBUILD_PHASE}

	if [[ ${PV} == 9999 ]] ; then
		# Need to copy stuff from dlg subproject (bug #758902)
		local dlg_inc_dir="${S}/subprojects/dlg/include/dlg"
		local dlg_src_dir="${S}/subprojects/dlg/src/dlg"
		local dlg_dest_dir="${S}/include"
		mkdir -p "${dlg_dest_dir}/dlg" || die
		cp "${dlg_inc_dir}"/{dlg,output}.h "${dlg_dest_dir}/dlg" || die
		cp "${dlg_src_dir}"/* "${dlg_dest_dir}" || die
	fi
}

src_prepare() {
	if [[ ${PV} == 9999 ]] ; then
		# Do NOT automagically mess with submodules!
		sed '/setup: copy_submodule/d' -i builds/toplevel.mk || die

		# Inspired by shipped autogen.sh script
		eval $(sed -n \
			-e 's/^#define  *\(FREETYPE_MAJOR\)  *\([0-9][0-9]*\).*/\1=\2/p' \
			-e 's/^#define  *\(FREETYPE_MINOR\)  *\([0-9][0-9]*\).*/\1=\2/p' \
			-e 's/^#define  *\(FREETYPE_PATCH\)  *\([0-9][0-9]*\).*/\1=\2/p' \
			include/freetype/freetype.h || die)
		FREETYPE="${FREETYPE_MAJOR}.${FREETYPE_MINOR}"
		[[ "${FREETYPE_PATCH}" != 0 ]] && FREETYPE+=".${FREETYPE_PATCH}"

		pushd builds/unix &>/dev/null || die
		sed -e "s;@VERSION@;${FREETYPE};" \
			< configure.raw > configure.ac || die
		unset FREETYPE_MAJOR FREETYPE_MINOR FREETYPE_PATCH FREETYPE
		popd &>/dev/null || die
	fi

	default

	pushd builds/unix &>/dev/null || die
	# eautoheader produces broken ftconfig.in
	AT_NOEAUTOHEADER="yes" AT_M4DIR="." eautoreconf
	popd &>/dev/null || die

	# This is the same as the 01 patch from infinality
	sed '/AUX_MODULES += \(gx\|ot\)valid/s@^# @@' -i modules.cfg || die

	enable_option() {
		sed -i -e "/#define $1/ { s:/\* ::; s: \*/:: }" \
			include/${PN}/config/ftoption.h \
			|| die "unable to enable option $1"
	}

	disable_option() {
		sed -i -e "/#define $1/ { s:^:/* :; s:$: */: }" \
			include/${PN}/config/ftoption.h \
			|| die "unable to disable option $1"
	}

	if ! use cleartype-hinting ; then
		disable_option TT_CONFIG_OPTION_SUBPIXEL_HINTING
	fi

	# Can be disabled with FREETYPE_PROPERTIES="pcf:no-long-family-names=1"
	# via environment (new since v2.8)
	enable_option PCF_CONFIG_OPTION_LONG_FAMILY_NAMES

	# See https://freetype.org/patents.html (expired!)
	enable_option FT_CONFIG_OPTION_SUBPIXEL_RENDERING

	if ! use adobe-cff ; then
		enable_option CFF_CONFIG_OPTION_OLD_ENGINE
	fi

	if use debug ; then
		enable_option FT_DEBUG_LEVEL_TRACE
		enable_option FT_DEBUG_MEMORY
	fi

	if use utils ; then
		cd "${WORKDIR}/ft2demos-${PV}" || die
		# Disable tests needing X11 when USE="-X". (bug #177597)
		if ! use X ; then
			sed -i -e "/EXES\ +=\ ftdiff/ s:^:#:" Makefile || die
		fi
		cd "${S}" || die
	fi

	# bug #869803
	rm docs/reference/sitemap.xml.gz || die

	# We need non-/bin/sh to run configure
	if [[ -n ${CONFIG_SHELL} ]] ; then
		sed -i -e "1s:^#![[:space:]]*/bin/sh:#!${CONFIG_SHELL}:" \
			"${S}"/builds/unix/configure || die
	fi

	elibtoolize --patch-only
}

multilib_src_configure() {
	export GNUMAKE=gmake

	local myeconfargs=(
		--disable-freetype-config
		--enable-shared
		--with-zlib
		$(use_with brotli)
		$(use_with bzip2)
		# As of 2.14.0, FT bundles its own copies of the needed headers and dlopen()s
		# harfbuzz instead, which breaks an insidious circular dependency.
		$(use_with harfbuzz harfbuzz dynamic)
		$(use_with png)
		$(use_enable static-libs static)
		$(usex utils $(use_with svg librsvg) --without-librsvg)

		# Avoid using libpng-config
		LIBPNG_CFLAGS="$($(tc-getPKG_CONFIG) --cflags libpng)"
		LIBPNG_LDFLAGS="$($(tc-getPKG_CONFIG) --libs libpng)"
	)

	case ${CHOST} in
		mingw*|*-mingw*) ;;
		# Workaround windows misdetection: bug #654712
		# Have to do it for both ${CHOST}-windres and windres
		*) myeconfargs+=( ac_cv_prog_RC= ac_cv_prog_ac_ct_RC= ) ;;
	esac

	export CC_BUILD="$(tc-getBUILD_CC)"

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use utils ; then
		einfo "Building utils"
		# Fix for Prefix, bug #339334
		emake \
			X11_PATH="${EPREFIX}/usr/$(get_libdir)" \
			FT2DEMOS=1 TOP_DIR_2="${WORKDIR}/ft2demos-${PV}"
	fi
}

multilib_src_install() {
	default

	if multilib_is_native_abi && use utils ; then
		einfo "Installing utils"
		emake DESTDIR="${D}" FT2DEMOS=1 \
			TOP_DIR_2="${WORKDIR}/ft2demos-${PV}" install
	fi
}

multilib_src_install_all() {
	if use fontforge ; then
		# fontforge can probably cope with fewer of these, but this is simpler
		einfo "Installing internal headers required for fontforge"
		local header
		find src/truetype include/freetype/internal -name '*.h' | \
		while read header ; do
			mkdir -p "${ED}/usr/include/freetype2/internal4fontforge/$(dirname ${header})" || die
			cp ${header} "${ED}/usr/include/freetype2/internal4fontforge/$(dirname ${header})" || die
		done
	fi

	dodoc docs/{CHANGES,CUSTOMIZE,DEBUG,INSTALL.UNIX,*.txt,PROBLEMS,TODO}
	if [[ ${PV} != 9999 ]] && use doc ; then
		docinto html
		dodoc -r docs/*
	fi

	find "${ED}" -type f -name '*.la' -delete || die
}

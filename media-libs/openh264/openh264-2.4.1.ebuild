# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs multilib-minimal

MOZVER=114_2
MY_GMP_COMMIT="e7d30b921df736a1121a0c8e0cf3ab1ce5b8a4b7"

DESCRIPTION="Cisco OpenH264 library and Gecko Media Plugin for Mozilla packages"
HOMEPAGE="https://www.openh264.org/ https://github.com/cisco/openh264"
SRC_URI="https://github.com/cisco/openh264/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/mozilla/gmp-api/archive/${MY_GMP_COMMIT}.tar.gz -> gmp-api-Firefox${MOZVER}-${MY_GMP_COMMIT}.tar.gz"
LICENSE="BSD"

# openh264 soname version.
# (2.2.0 needed a minor bump due to undocumented but breaking ABI changes, just to be sure.
#  https://github.com/cisco/openh264/issues/3459 )
SLOT="0/7"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc64 ~riscv ~sparc x86"
IUSE="cpu_flags_arm_neon cpu_flags_x86_avx2 +plugin test utils"

RESTRICT="bindist !test? ( test )"

BDEPEND="
	abi_x86_32? ( dev-lang/nasm )
	abi_x86_64? ( dev-lang/nasm )
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )"

DOCS=( LICENSE CONTRIBUTORS README.md )

PATCHES=(
	"${FILESDIR}"/openh264-2.3.0-pkgconfig-pathfix.patch
	"${FILESDIR}"/${PN}-2.3.1-pr3630.patch
)

src_prepare() {
	default

	ln -svf "/dev/null" "build/gtest-targets.mk" || die
	sed -i -e 's/$(LIBPREFIX)gtest.$(LIBSUFFIX)//g' Makefile || die

	sed -i -e 's/ | generate-version//g' Makefile || die
	sed -e 's|$FULL_VERSION|""|g' codec/common/inc/version_gen.h.template > \
		codec/common/inc/version_gen.h

	multilib_copy_sources
}

multilib_src_configure() {
	ln -s "${WORKDIR}"/gmp-api-${MY_GMP_COMMIT} gmp-api || die
}

emakecmd() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" AR="$(tc-getAR)" \
	emake V=Yes CFLAGS_M32="" CFLAGS_M64="" CFLAGS_OPT="" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR_NAME="$(get_libdir)" \
		SHAREDLIB_DIR="${EPREFIX}/usr/$(get_libdir)" \
		INCLUDES_DIR="${EPREFIX}/usr/include/${PN}" \
		HAVE_AVX2=$(usex cpu_flags_x86_avx2 Yes No) \
		HAVE_GTEST=$(usex test Yes No) \
		ARCH="$(tc-arch)" \
		ENABLEPIC="Yes" \
		$@
}

multilib_src_compile() {
	local myopts="ENABLE64BIT=No"
	case "${ABI}" in
		s390x|alpha|*64) myopts="ENABLE64BIT=Yes";;
	esac

	if use arm; then
		myopts+=" USE_ASM=$(usex cpu_flags_arm_neon Yes No)"
	fi

	emakecmd ${myopts}
	use plugin && emakecmd ${myopts} plugin
}

multilib_src_test() {
	emakecmd test
}

multilib_src_install() {
	emakecmd DESTDIR="${D}" install-shared

	if use utils; then
		newbin h264enc openh264enc
		newbin h264dec openh264dec
	fi

	if use plugin; then
		local plugpath="${ROOT}/usr/$(get_libdir)/nsbrowser/plugins/gmp-gmp${PN}/system-installed"
		insinto "${plugpath}"
		doins libgmpopenh264.so* gmpopenh264.info
		echo "MOZ_GMP_PATH=\"${plugpath}\"" >"${T}"/98-moz-gmp-${PN}
		doenvd "${T}"/98-moz-gmp-${PN}

		cat <<PREFEOF >"${T}"/${P}.js
pref("media.gmp-gmp${PN}.autoupdate", false);
pref("media.gmp-gmp${PN}.version", "system-installed");
PREFEOF

		insinto /usr/$(get_libdir)/firefox/defaults/pref
		newins "${T}"/${P}.js ${PN}-${PV/_p*/}.js

		insinto /usr/$(get_libdir)/seamonkey/defaults/pref
		newins "${T}"/${P}.js ${PN}-${PV/_p*/}.js
	fi
}

pkg_postinst() {
	if use plugin; then
		if [[ -z ${REPLACING_VERSIONS} ]]; then
			elog "Please restart your login session, in order for the session's environment"
			elog "to include the new MOZ_GMP_PATH variable."
			elog ""
		fi
		elog "This package attempts to override the Mozilla GMPInstaller auto-update process,"
		elog "however even if it is not successful in doing so the profile-installed plugin"
		elog "will not be used unless this package is removed.  This package will take precedence"
		elog "over any gmp-gmpopenh264 that may be installed in a user's profile."
		elog ""
	fi

	if use utils; then
		elog "Utilities h264enc and h264dec are installed as openh264enc and openh264dec"
		elog "to avoid file collisions with media-video/h264enc"
		elog ""
	fi
}

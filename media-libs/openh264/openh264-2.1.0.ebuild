# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib-minimal

MOZVER=39
DESCRIPTION="Cisco OpenH264 library and Gecko Media Plugin for Mozilla packages"
HOMEPAGE="https://www.openh264.org/"
SRC_URI="https://github.com/cisco/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/mozilla/gmp-api/archive/Firefox${MOZVER}.tar.gz -> gmp-api-Firefox${MOZVER}.tar.gz"
LICENSE="BSD"
SLOT="0/5" # subslot = openh264 soname version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="cpu_flags_x86_avx2 +plugin utils"

RESTRICT="bindist test"

BDEPEND="
	abi_x86_32? ( dev-lang/nasm )
	abi_x86_64? ( dev-lang/nasm )"

DOCS=( LICENSE CONTRIBUTORS README.md )

PATCHES=( "${FILESDIR}/${PN}-2.1.0-pkgconfig-pathfix.patch" )

src_prepare() {
	default

	multilib_copy_sources
}

multilib_src_configure() {
	ln -s "${WORKDIR}"/gmp-api-Firefox${MOZVER} gmp-api || die
}

emakecmd() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	emake V=Yes CFLAGS_M32="" CFLAGS_M64="" CFLAGS_OPT="" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR_NAME="$(get_libdir)" \
		SHAREDLIB_DIR="${EPREFIX}/usr/$(get_libdir)" \
		INCLUDES_DIR="${EPREFIX}/usr/include/${PN}" \
		HAVE_AVX2=$(usex cpu_flags_x86_avx2 Yes No) \
		$@
}

multilib_src_compile() {
	local mybits="ENABLE64BIT=No"
	case "${ABI}" in
		s390x|alpha|*64) mybits="ENABLE64BIT=Yes";;
	esac

	emakecmd ${mybits}
	use plugin && emakecmd ${mybits} plugin
}

multilib_src_install() {
	emakecmd DESTDIR="${D}" install-shared

	if use utils; then
		newbin h264enc openh264enc
		newbin h264dec openh264dec
	fi

	if use plugin; then
		local plugpath="${EROOT}/usr/$(get_libdir)/nsbrowser/plugins/gmp-gmp${PN}/system-installed"
		insinto "${plugpath}"
		doins libgmpopenh264.so* gmpopenh264.info
		echo "MOZ_GMP_PATH=\"${plugpath}\"" >"${T}"/98-moz-gmp-${PN}
		doenvd "${T}"/98-moz-gmp-${PN}

		cat <<PREFEOF >"${T}"/${P}.js
pref("media.gmp-gmp${PN}.autoupdate", false);
pref("media.gmp-gmp${PN}.version", "system-installed");
PREFEOF

		insinto /usr/$(get_libdir)/firefox/defaults/pref
		doins "${T}"/${P}.js

		insinto /usr/$(get_libdir)/seamonkey/defaults/pref
		doins "${T}"/${P}.js
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

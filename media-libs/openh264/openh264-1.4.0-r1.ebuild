# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit nsplugins multilib-minimal

MOZVER=38
DESCRIPTION="Cisco OpenH264 library and Gecko Media Plugin for Mozilla packages"
HOMEPAGE="http://www.openh264.org/"
SRC_URI="https://github.com/cisco/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/mozilla/gmp-api/archive/Firefox${MOZVER}.tar.gz -> gmp-api-Firefox${MOZVER}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+plugin utils"

RESTRICT="bindist"

RDEPEND="!<www-client/firefox-${MOZVER}"
DEPEND="dev-lang/nasm"

DOCS=( LICENSE CONTRIBUTORS README.md )

src_prepare() {
	epatch "${FILESDIR}"/pkgconfig-pathfix.patch
	epatch "${FILESDIR}"/pkgconfig_install.patch
	multilib_copy_sources
}

multilib_src_configure() {
	ln -s "${WORKDIR}"/gmp-api-Firefox${MOZVER} gmp-api || die
}

emakecmd() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	emake V=Yes CFLAGS_M32="" CFLAGS_M64="" CFLAGS_OPT="" \
		PREFIX="${EPREFIX}/usr" \
		SHAREDLIB_DIR="${EPREFIX}/usr/$(get_libdir)" \
		INCLUDES_DIR="${EPREFIX}/usr/include/${PN}" \
		$@
}

multilib_src_compile() {
	local mybits="ENABLE64BIT=No"
	case "${ABI}" in
		s390x|alpha|*64) mybits="ENABLE64BIT=Yes";;
	esac

	emakecmd ${mybits} ${tgt}
	use plugin && emakecmd ${mybits} plugin
}

multilib_src_install() {
	emakecmd DESTDIR="${D}" install-shared

	use utils && dobin h264{enc,dec}

	if use plugin; then
		local plugpath="usr/$(get_libdir)/${PLUGINS_DIR}/gmp-gmp${PN}/system-installed"
		insinto "/${plugpath}"
		doins libgmpopenh264.so* gmpopenh264.info
		echo "MOZ_GMP_PATH=\"${EROOT}${plugpath}\"" >"${T}"/98-moz-gmp-${PN}
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
}

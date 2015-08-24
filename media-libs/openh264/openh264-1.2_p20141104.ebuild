# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit nsplugins

DESCRIPTION="Cisco OpenH264 library and Gecko Media Plugin for mozilla packages"
HOMEPAGE="http://www.openh264.org/"
SRC_URI="https://dev.gentoo.org/~axs/distfiles/gmp-${P}.tar.xz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+plugin"

RESTRICT="bindist"

RDEPEND=""
DEPEND="dev-lang/nasm"

DOCS=( LICENSE CONTRIBUTORS README.md )

S=${WORKDIR}/gmp-${P}

src_compile() {
	local mybits="ENABLE64BIT=No"
	case "${ABI}" in
		s390x|alpha|*64) mybits="ENABLE64BIT=Yes";;
	esac
	emake V=Yes ${mybits}
	use plugin && emake V=Yes ${mybits} plugin
}

src_install() {
	emake PREFIX="${ED}usr" LIBPREFIX="${ED}usr/$(get_libdir)/" \
		install-headers

	dolib libopenh264.so

	if use plugin; then
		local plugpath="usr/$(get_libdir)/${PLUGINS_DIR}/gmp-gmp${PN}/system-installed"
		insinto "/${plugpath}"
		doins libgmpopenh264.so gmpopenh264.info
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
		elog "This package attempts to override the mozilla GMPInstaller auto-update process,"
		elog "however even if it is not successful in doing so the profile-installed plugin"
		elog "will not be used unless this package is removed.  This package will take precedence"
		elog "over any gmp-gmpopenh264 that may be installed in a user's profile."
		elog ""
	fi
}

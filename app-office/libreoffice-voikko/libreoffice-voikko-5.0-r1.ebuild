# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit verify-sig

DESCRIPTION="Free Finnish spell checking and hyphenation for LibreOffice"
HOMEPAGE="https://voikko.puimula.org/"
SRC_URI="https://www.puimula.org/voikko-sources/${PN}/${P}.tar.gz
	verify-sig? ( https://www.puimula.org/voikko-sources/libreoffice-voikko/${P}.tar.gz.asc )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="|| (
		app-office/libreoffice[odk]
		>=app-office/libreoffice-bin-6.4.7.2_p1
	)
	dev-libs/voikko-fi"
RDEPEND="${DEPEND}
	dev-libs/libvoikko"
BDEPEND="verify-sig? ( app-crypt/openpgp-keys-voikko )"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/voikko.asc

src_compile() {
	emake oxt
}

src_install() {
	einstalldocs

	emake DESTDIR="${D}/usr/$(get_libdir)/${P}" install-unpacked

	insinto /usr/$(get_libdir)/libreoffice/share/extension/install/
	doins build/voikko.oxt
}

pkg_postinst() {
	# Register voikko with libreoffice
	COMPONENT="${ROOT}/usr/$(get_libdir)/libreoffice/share/extension/install/voikko.oxt"

	einfo "Trying to register ${COMPONENT} ..."
	unopkg add --shared "${COMPONENT}"
	if [[ ${?} == 0 ]] ; then
		einfo "${PN} registered succesfully with LibreOffice."
	else
		eerror "Couldn't register ${PN} with LibreOffice."
	fi
}

pkg_prerm() {
	# Remove voikko registration from libreoffice
	unopkg remove --shared org.puimula.ooovoikko
	if [[ ${?} == 0 ]] ; then
		einfo "${PN} removed succesfully from LibreOffice."
	else
		eerror "Couldn't remove ${PN} from LibreOffice, "
		eerror "manual removal might be needed with "
		eerror "  unopkg list --shared"
		eerror "  unopkg remove --shared VOIKKO-IDENTIFIER"
	fi
}

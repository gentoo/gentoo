# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SWORD_MINIMUM_VERSION="1.5.6"

inherit sword-module

DESCRIPTION="Hoffnung fuer alle - Die Bibel"
HOMEPAGE="https://crosswire.org/sword/modules/ModInfo.jsp?modName=GerHfa2002"
LICENSE="sword-GerHfa2002"
KEYWORDS="~amd64 ~ppc ~x86"

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "This SWORD module is locked. If you haven't done so yet, please visit"
		elog
		elog "https://crosswire.org/sword/modules/registration/gerhfa2002.jsp"
		elog "(in German only)"
		elog
		elog "for information about purchasing and installing an unlock key."
	fi
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Auscrie, LeechCraft auto screenshooter"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}"

pkg_postinst() {
	elog "Consider also the following plugins:"
	optfeature "uploading screenshots to imagebins" app-leechcraft/lc-imgaste
	optfeature "uploading screenshots to cloud photo hostings" app-leechcraft/lc-blasq
	optfeature "uploading screenshots to cloud drives" app-leechcraft/lc-netstoremanager
}

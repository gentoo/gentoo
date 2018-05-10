# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="true"
inherit kde5

DESCRIPTION="Job-based library to send email through an SMTP server"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_kdeapps_dep kmime)
	$(add_qt_dep qtnetwork)
	dev-libs/cyrus-sasl
"
RDEPEND="${DEPEND}"

RESTRICT+=" test" # bug 642410

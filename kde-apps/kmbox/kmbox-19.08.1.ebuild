# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
inherit kde5

DESCRIPTION="Library for accessing MBox format mail storages"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="$(add_kdeapps_dep kmime)"
RDEPEND="${DEPEND}"

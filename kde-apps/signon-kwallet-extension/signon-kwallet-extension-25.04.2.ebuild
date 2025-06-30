# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.13.0
inherit ecm gear.kde.org

DESCRIPTION="KWallet extension for signond"
HOMEPAGE="https://accounts-sso.gitlab.io/"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="amd64 ~arm64"

DEPEND="
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=net-libs/signond-8.61-r100[qt6(+)]
"
RDEPEND="${DEPEND}"

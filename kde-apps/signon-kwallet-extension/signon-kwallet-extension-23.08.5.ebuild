# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.106.0
inherit ecm gear.kde.org

DESCRIPTION="KWallet extension for signond"
HOMEPAGE="https://accounts-sso.gitlab.io/"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 ~riscv x86"

DEPEND="
	>=kde-frameworks/kwallet-${KFMIN}:5
	net-libs/signond[qt5(+)]
"
RDEPEND="${DEPEND}"

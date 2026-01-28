# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=6.22.0
PVCUT=$(ver_cut 1-3)
inherit ecm gear.kde.org

DESCRIPTION="Library for accessing MBox format mail storages"

LICENSE="GPL-2+"
SLOT="6/$(ver_cut 1-2)"
KEYWORDS="amd64 arm64"
IUSE=""

DEPEND=">=kde-apps/kmime-${PVCUT}:6="
RDEPEND="${DEPEND}"

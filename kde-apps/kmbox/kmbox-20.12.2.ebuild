# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
inherit ecm kde.org

DESCRIPTION="Library for accessing MBox format mail storages"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE=""

DEPEND=">=kde-apps/kmime-${PVCUT}:5"
RDEPEND="${DEPEND}"

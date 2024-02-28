# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing access to Open Collaboration Services"

LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND=">=dev-qt/qtnetwork-${QTMIN}:5"
DEPEND="${RDEPEND}"

CMAKE_SKIP_TESTS=(
	# requires network access, bug #661230
	providertest
)

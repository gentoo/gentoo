# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Transitional package to pull in plasma-meta plus basic applications"
HOMEPAGE="https://kde.org/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE=""

RDEPEND="
	>=kde-apps/kdecore-meta-${PV}:${SLOT}
	kde-plasma/plasma-meta
"

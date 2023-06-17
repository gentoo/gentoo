# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdeaccessibility - merge this to pull in all kdeaccessiblity-derived packages"
HOMEPAGE="https://apps.kde.org/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 arm64 ~riscv x86"
IUSE=""

RDEPEND="
	>=app-accessibility/kontrast-${PV}:${SLOT}
	>=kde-apps/kmag-${PV}:${SLOT}
	>=kde-apps/kmousetool-${PV}:${SLOT}
	>=kde-apps/kmouth-${PV}:${SLOT}
"

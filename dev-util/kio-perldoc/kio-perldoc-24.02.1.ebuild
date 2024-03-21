# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="kdesdk-kio"
KFMIN=5.115.0
inherit ecm gear.kde.org

DESCRIPTION="KIO worker interface to browse Perl documentation"

LICENSE="GPL-2+ || ( Artistic GPL-1+ )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE=""

DEPEND="
	dev-lang/perl
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
"
RDEPEND="${DEPEND}"

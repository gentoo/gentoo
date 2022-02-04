# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=5.84.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Job-based library to send email through an SMTP server"
HOMEPAGE="https://api.kde.org/kdepim/ksmtp/html/index.html"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${P}-CVE-2021-38373.patch.xz"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE=""

RESTRICT="test" # bug 642410

DEPEND="
	dev-libs/cyrus-sasl
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${WORKDIR}/${P}-CVE-2021-38373.patch" )

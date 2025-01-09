# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=6.7.0
inherit ecm gear.kde.org

DESCRIPTION="Libary for handling mail messages and newsgroup articles"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND=">=kde-frameworks/kcodecs-${KFMIN}:6"
RDEPEND="${DEPEND}"

CMAKE_SKIP_TESTS=(
	# bug 924507
	kmime-{header,message}test
)

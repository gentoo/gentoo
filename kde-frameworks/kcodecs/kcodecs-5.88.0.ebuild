# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Framework for manipulating strings using various encodings"
LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="nls"

BDEPEND="
	dev-util/gperf
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PythonModuleGeneration=ON # bug 746866
	)
	ecm_src_configure
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic

DESCRIPTION="C++ library offering some basic functionality for platform-independent programs"
HOMEPAGE="https://lib.filezilla-project.org/"
SRC_URI="https://download.filezilla-project.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ~ppc x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="dev-libs/nettle:0="
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if ! test-flag-CXX -std=c++14; then
			eerror "${P} requires C++14-capable C++ compiler. Your current compiler"
			eerror "does not seem to support -std=c++14 option. Please upgrade your compiler"
			eerror "to gcc-4.9 or an equivalent version supporting C++14."
			die "Currently active compiler does not support -std=c++14"
		fi
	fi
}

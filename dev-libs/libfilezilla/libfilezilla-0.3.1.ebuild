# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit flag-o-matic

DESCRIPTION="C++ library offering some basic functionality for platform-independent programs"
HOMEPAGE="https://lib.filezilla-project.org/"
SRC_URI="mirror://sourceforge/filezilla/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
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

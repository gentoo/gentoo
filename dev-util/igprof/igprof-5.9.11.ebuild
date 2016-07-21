# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Ignominous Profiler for analysing application memory and performance characteristics"
HOMEPAGE="http://igprof.org"
SRC_URI="https://github.com/ktf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

# pcre is automagic dependency, let's make it unoptional
# libatomic_ops is listed as dependency, but isn't actually used by package
DEPEND="dev-libs/libpcre
		sys-libs/libunwind"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e 's/-Werror//g' -i CMakeLists.txt
	cmake-utils_src_prepare
}

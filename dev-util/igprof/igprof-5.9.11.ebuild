# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/igprof/igprof-5.9.11.ebuild,v 1.1 2014/01/08 12:13:50 maksbotan Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Ignominous Profiler for analysing application memory and performance characteristics"
HOMEPAGE="http://igprof.org"
SRC_URI="http://github.com/ktf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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

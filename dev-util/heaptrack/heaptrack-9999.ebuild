# Copyright 2015-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/heaptrack/heaptrack-9999.ebuild,v 1.2 2015/05/18 18:16:32 zzam Exp $

EAPI=5

EGIT_REPO_URI="git://anongit.kde.org/heaptrack"
[[ ${PV} = 9999 ]] && inherit git-r3
inherit cmake-utils

DESCRIPTION="A fast heap memory profiler"
HOMEPAGE="http://milianw.de/blog/heaptrack-a-heap-memory-profiler-for-linux"
[[ ${PV} = 9999 ]] || SRC_URI="${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} = 9999 ]] || \
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-libs/libunwind
	>=dev-libs/boost-1.41.0"
DEPEND="${RDEPEND}"

DOCS=()
[[ ${PV} = 9999 ]] || DOCS+=( ChangeLog )

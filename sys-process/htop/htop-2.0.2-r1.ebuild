# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools linux-info

DESCRIPTION="interactive process viewer"
HOMEPAGE="http://hisham.hm/htop/"
SRC_URI="http://hisham.hm/htop/releases/${PV}/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="files kernel_FreeBSD kernel_linux openvz unicode vserver"

RDEPEND="sys-libs/ncurses:0=[unicode?]
	files? ( sys-process/lsof )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog README )

CONFIG_CHECK="~TASKSTATS ~TASK_XACCT ~TASK_IO_ACCOUNTING ~CGROUPS"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.2-tinfo.patch"
)

src_prepare() {
	rm missing || die

	default
	eautoreconf
}

src_configure() {
	[[ $CBUILD != $CHOST ]] && export ac_cv_file__proc_{meminfo,stat}=yes #328971

	local myeconfargs=()

	myeconfargs+=(
		# fails to build against recent hwloc versions
		--disable-hwloc
		--enable-taskstats
		$(use_enable kernel_linux cgroup)
		$(use_enable kernel_linux linux-affinity)
		$(use_enable openvz)
		$(use_enable unicode)
		$(use_enable vserver)
	)
	econf ${myeconfargs[@]}
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils linux-info

DESCRIPTION="interactive process viewer"
HOMEPAGE="http://hisham.hm/htop/"
SRC_URI="http://hisham.hm/htop/releases/${PV}/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="kernel_FreeBSD kernel_linux oom openvz unicode vserver"

RDEPEND="sys-libs/ncurses:0=[unicode?]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog README )

CONFIG_CHECK="~TASKSTATS ~TASK_XACCT ~TASK_IO_ACCOUNTING ~CGROUPS"

# config.h problems
AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=("${FILESDIR}/${P}-tinfo.patch")

pkg_setup() {
	if use kernel_FreeBSD && ! [[ -f ${ROOT}/compat/linux/proc/stat && -f ${ROOT}/compat/linux/proc/meminfo ]]; then
		echo
		eerror "htop requires linprocfs mounted at /compat/linux/proc to build and function."
		eerror "To mount it, type:"
		[ -d /compat/linux/proc ] || eerror "mkdir -p /compat/linux/proc"
		eerror "mount -t linprocfs none /compat/linux/proc"
		eerror "Alternatively, place this information into /etc/fstab"
		echo
		die "htop needs /compat/linux/proc mounted"
	fi

	if ! has_version sys-process/lsof; then
		ewarn "To use lsof features in htop(what processes are accessing"
		ewarn "what files), you must have sys-process/lsof installed."
	fi

	linux-info_pkg_setup
}

src_prepare() {
	rm missing || die

	autotools-utils_src_prepare
}

src_configure() {
	[[ $CBUILD != $CHOST ]] && export ac_cv_file__proc_{meminfo,stat}=yes #328971

	local myeconfargs=()

	use kernel_FreeBSD && myeconfargs+=( --with-proc=/compat/linux/proc )

	myeconfargs+=(
		$(use_enable openvz)
		$(use_enable kernel_linux cgroup)
		$(use_enable vserver)
		$(use_enable unicode)
		$(use_enable oom)
		--enable-taskstats
		)
	autotools-utils_src_configure
}

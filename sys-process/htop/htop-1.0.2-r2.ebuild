# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils linux-info python-any-r1

DESCRIPTION="interactive process viewer"
HOMEPAGE="http://htop.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="kernel_FreeBSD kernel_linux openvz unicode vserver"

RDEPEND="sys-libs/ncurses[unicode?]"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README )

CONFIG_CHECK="~TASKSTATS ~TASK_XACCT ~TASK_IO_ACCOUNTING ~CGROUPS"

# config.h problems
AUTOTOOLS_IN_SOURCE_BUILD=1

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
	python-any-r1_pkg_setup
	linux-info_pkg_setup
}

PATCHES=(
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-process.patch
	"${FILESDIR}"/${P}-out-of-src.patch
)

src_prepare() {
	rm missing || die
	sed \
		-e '1c\#!'"${EPREFIX}"'/usr/bin/python' \
		-i scripts/MakeHeader.py || die
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
		--enable-taskstats
		)
	autotools-utils_src_configure
}

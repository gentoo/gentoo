# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PYTHON_DEPEND="gtk? 2"
inherit autotools eutils python

DESCRIPTION="Support programs for the Oracle Cluster Filesystem 2"
HOMEPAGE="http://oss.oracle.com/projects/ocfs2-tools/"
SRC_URI="https://dev.gentoo.org/~alexxy/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug external gtk"

RDEPEND="
	dev-libs/libaio
	sys-apps/util-linux
	sys-cluster/libcman
	external? (
		sys-cluster/libdlm
		sys-cluster/pacemaker[-heartbeat]
		)
	sys-fs/e2fsprogs
	sys-libs/ncurses
	sys-libs/readline
	sys-process/psmisc
	gtk? (
		dev-python/pygtk
	)
"
# 99% of deps this thing has is automagic
# specialy cluster things corosync/pacemaker
DEPEND="${RDEPEND}"

DOCS=(
	"${S}/documentation/samples/cluster.conf"
	"${S}/documentation/users_guide.txt"
)

MAKEOPTS+=" -j1"

PATCHES=(
		"${FILESDIR}/${PN}-1.6.4-asneeded.patch"
		"${FILESDIR}/${PN}-recent-kernels.patch"
		)

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -e 's/ncurses, tgetstr/ncurses, printw/g' -i configure.in || die
	# gentoo uses /sys/kernel/dlm as dlmfs mountpoint
	sed -e 's:"/dlm/":"/sys/kernel/dlm":g' \
		-i libo2dlm/o2dlm_test.c \
		-i libocfs2/dlm.c || die "sed failed"
	epatch ${PATCHES[@]}
	rm -f aclocal.m4
	AT_M4DIR=. eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug debug) \
		$(use_enable debug debugexe) \
		$(use_enable gtk ocfs2console) \
		--enable-dynamic-fsck \
		--enable-dynamic-ctl
}

src_install() {
	default
	newinitd "${FILESDIR}/ocfs2.initd" ocfs2
	newconfd "${FILESDIR}/ocfs2.confd" ocfs2
}

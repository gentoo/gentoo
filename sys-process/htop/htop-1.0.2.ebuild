# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/htop/htop-1.0.2.ebuild,v 1.11 2014/02/03 16:43:30 jlec Exp $

EAPI=4

DESCRIPTION="interactive process viewer"
HOMEPAGE="http://htop.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="kernel_FreeBSD kernel_linux openvz unicode vserver"

RDEPEND="sys-libs/ncurses[unicode?]"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README )

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
}

src_prepare() {
	sed -i -e '1c\#!'"${EPREFIX}"'/usr/bin/python' \
		scripts/MakeHeader.py || die
}

src_configure() {
	[[ $CBUILD != $CHOST ]] && export ac_cv_file__proc_{meminfo,stat}=yes #328971

	local myconf=''

	use kernel_FreeBSD && myconf="${myconf} --with-proc=/compat/linux/proc"

	econf \
		$(use_enable openvz) \
		$(use_enable kernel_linux cgroup) \
		$(use_enable vserver) \
		$(use_enable unicode) \
		--enable-taskstats \
		${myconf}
}

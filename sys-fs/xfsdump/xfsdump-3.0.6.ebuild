# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/xfsdump/xfsdump-3.0.6.ebuild,v 1.7 2012/05/06 16:27:34 armin76 Exp $

EAPI="2"

inherit multilib eutils

DESCRIPTION="xfs dump/restore utilities"
HOMEPAGE="http://oss.sgi.com/projects/xfs"
SRC_URI="ftp://oss.sgi.com/projects/xfs/cmd_tars/${P}.tar.gz
	ftp://oss.sgi.com/projects/xfs/previous/cmd_tars/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 -sparc x86"
IUSE=""

RDEPEND="sys-fs/e2fsprogs
	!<sys-fs/xfsprogs-3
	sys-apps/dmapi
	>=sys-apps/attr-2.4.19"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_prepare() {
	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:${PF}:" \
		include/builddefs.in \
		|| die
	epatch "${FILESDIR}"/${PN}-3.0.5-prompt-overflow.patch #335115
	epatch "${FILESDIR}"/${PN}-3.0.4-no-symlink.patch #311881
	epatch "${FILESDIR}"/${PN}-3.0.6-path-overflow.patch #370949
}

src_configure() {
	unset PLATFORM #184564
	export OPTIMIZER=${CFLAGS}
	export DEBUG=-DNDEBUG

	econf \
		--libdir=/$(get_libdir) \
		--libexecdir=/usr/$(get_libdir) \
		--sbindir=/sbin
}

src_install() {
	emake DIST_ROOT="${D}" install || die
	prepalldocs
}

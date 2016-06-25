# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit multilib eutils flag-o-matic

DESCRIPTION="xfs dump/restore utilities"
HOMEPAGE="http://oss.sgi.com/projects/xfs"
SRC_URI="ftp://oss.sgi.com/projects/xfs/cmd_tars/${P}.tar.gz
	ftp://oss.sgi.com/projects/xfs/previous/cmd_tars/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc ppc64 -sparc x86"
IUSE="nls"

RDEPEND="sys-fs/e2fsprogs
	>=sys-fs/xfsprogs-3.2.0
	sys-apps/dmapi
	>=sys-apps/attr-2.4.19"
DEPEND="${RDEPEND}
	nls? (
		sys-devel/gettext
		elibc_uclibc? ( dev-libs/libintl )
	)"

src_prepare() {
	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:${PF}:" \
		include/builddefs.in \
		|| die
	epatch "${FILESDIR}"/${PN}-3.0.5-prompt-overflow.patch #335115
	epatch "${FILESDIR}"/${PN}-3.0.4-no-symlink.patch #311881
	epatch "${FILESDIR}"/${PN}-3.1.6-linguas.patch #561664
}

src_configure() {
	unset PLATFORM #184564
	export OPTIMIZER=${CFLAGS}
	export DEBUG=-DNDEBUG

	econf \
		$(use_enable nls gettext) \
		--libdir="${EPREFIX}/$(get_libdir)" \
		--libexecdir="${EPREFIX}/usr/$(get_libdir)" \
		--sbindir="${EPREFIX}/sbin"
}

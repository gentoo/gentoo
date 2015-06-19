# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/nmh/nmh-1.3-r3.ebuild,v 1.4 2012/11/30 23:07:47 radhermit Exp $

EAPI="2"

inherit eutils base

DESCRIPTION="New MH mail reader"
HOMEPAGE="http://www.nongnu.org/nmh/"
SRC_URI="http://savannah.nongnu.org/download/nmh/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gdbm"

DEPEND="gdbm? ( sys-libs/gdbm )
	!gdbm? ( sys-libs/db )
	>=sys-libs/ncurses-5.2
	net-libs/liblockfile
	>=app-misc/editor-wrapper-3
	!!media-gfx/pixie" # Bug #295996 media-gfx/pixie also uses show
RDEPEND="${DEPEND}"

DOCS=( ChangeLog DATE MACHINES README )

src_prepare() {
	# Patches from bug #22173.
	epatch "${FILESDIR}"/${P}-inc-login.patch
	epatch "${FILESDIR}"/${P}-install.patch
	# bug #57886
	epatch "${FILESDIR}"/${P}-m_getfld.patch
	# bug #319937
	epatch "${FILESDIR}"/${P}-db5.patch
	# Allow parallel compiles/installs
	epatch "${FILESDIR}"/${P}-parallelmake.patch
}

src_configure() {
	# Bug 348816 & Bug 341741: The previous ebuild default of
	# /usr/bin caused unnecessary conflicts with other
	# packages. However, the default nmh libdir location causes
	# problems with cross-compiling, so we use, eg., /usr/lib64.
	# Users may use /usr/lib/nmh in scripts needing these support
	# programs in normal environments.
	local myconf="--libdir=/usr/$(get_libdir)/nmh"

	# Have gdbm use flag actually control which version of db in use
	if use gdbm; then
		myconf="${myconf} --with-ndbmheader=gdbm/ndbm.h --with-ndbm=gdbm_compat"
	else
		if has_version ">=sys-libs/db-2"; then
			myconf="${myconf} --with-ndbmheader=db.h --with-ndbm=db"
		else
			myconf="${myconf} --with-ndbmheader=db1/ndbm.h --with-ndbm=db1"
		fi
	fi

	# use wrapper scripts to avoid implicit dependencies (Bug #294762)
	EDITOR=/usr/libexec/editor
	PAGER=/usr/libexec/pager

	econf \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--with-editor="${EDITOR}" \
		--with-pager="${PAGER}" \
		--enable-nmh-pop \
		--sysconfdir=/etc/nmh \
		${myconf}
}

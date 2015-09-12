# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs multilib multilib-minimal

DESCRIPTION="XFS data management API library"
HOMEPAGE="http://oss.sgi.com/projects/xfs/"
SRC_URI="ftp://oss.sgi.com/projects/xfs/cmd_tars/${P}.tar.gz
	ftp://oss.sgi.com/projects/xfs/previous/cmd_tars/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="static-libs"

RDEPEND="sys-fs/xfsprogs"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:${PF}:" \
		include/builddefs.in \
		|| die
	epatch "${FILESDIR}"/${P}-headers.patch

	multilib_copy_sources
}

multilib_src_configure() {
	export OPTIMIZER=${CFLAGS}
	export DEBUG=-DNDEBUG

	econf \
		--libexecdir=/usr/$(get_libdir) \
		$(use_enable static-libs static)
}

multilib_src_install() {
	emake DESTDIR="${D}" install install-dev
	multilib_is_native_abi && gen_usr_ldscript -a dm
}

multilib_src_install_all() {
	prune_libtool_files --all
	rm "${ED}"/usr/share/doc/${PF}/COPYING
}

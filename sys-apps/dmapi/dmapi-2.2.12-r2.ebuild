# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal usr-ldscript

DESCRIPTION="XFS data management API library"
HOMEPAGE="https://xfs.wiki.kernel.org/"
SRC_URI="ftp://oss.sgi.com/projects/xfs/cmd_tars/${P}.tar.gz
	ftp://oss.sgi.com/projects/xfs/previous/cmd_tars/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"
IUSE="static-libs"

RDEPEND="sys-fs/xfsprogs"
DEPEND="${RDEPEND}"

DOCS=( doc/{CHANGES,PORTING} README )

PATCHES=(
	"${FILESDIR}"/${P}-headers.patch
	"${FILESDIR}"/${P}-no-doc.patch # bug 732042
)

src_prepare() {
	default
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
	gen_usr_ldscript -a dm
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Creation/expansion of ISO-9660 filesystems on CD/DVD media supported by libburn"
HOMEPAGE="http://libburnia-project.org/"
SRC_URI="http://files.libburnia-project.org/releases/${P}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 x86"
IUSE="acl cdio debug external-filters external-filters-setuid frontend-optional
	launch-frontend launch-frontend-setuid libedit readline static-libs xattr zlib"

REQUIRED_USE="frontend-optional? ( || ( launch-frontend launch-frontend-setuid ) )"

RDEPEND=">=dev-libs/libburn-1.3.8
	>=dev-libs/libisofs-1.3.8
	readline? ( sys-libs/readline:0= )
	!readline? ( libedit? ( dev-libs/libedit ) )
	acl? ( virtual/acl )
	xattr? ( sys-apps/attr )
	zlib? ( sys-libs/zlib )
	cdio? ( >=dev-libs/libcdio-0.83 )
	launch-frontend? ( dev-lang/tcl:0 dev-lang/tk:0 )
	launch-frontend-setuid? ( dev-lang/tcl:0 dev-lang/tk:0 )
	frontend-optional? ( dev-tcltk/bwidget )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
	$(use_enable static-libs static) \
	$(use_enable readline libreadline) \
	$(usex readline --disable-libedit $(use_enable libedit)) \
	$(use_enable acl libacl) \
	$(use_enable xattr) \
	$(use_enable zlib) \
	--disable-libjte \
	$(use_enable cdio libcdio) \
	$(use_enable external-filters) \
	$(use_enable external-filters-setuid) \
	$(use_enable launch-frontend) \
	$(use_enable launch-frontend-setuid) \
	--disable-ldconfig-at-install \
	--enable-pkg-check-modules \
	$(use_enable debug)
}

src_install() {
	default

	dodoc CONTRIBUTORS doc/{comments,*.wiki,startup_file.txt}

	docinto frontend
	dodoc frontend/README-tcltk
	docinto xorriso
	dodoc xorriso/{changelog.txt,README_gnu_xorriso}
	docinto xorriso/html

	prune_libtool_files --all
}

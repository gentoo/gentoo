# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/xfsprogs/xfsprogs-3.2.4.ebuild,v 1.2 2015/07/30 18:13:29 zlogene Exp $

EAPI="4"

inherit eutils toolchain-funcs multilib

DESCRIPTION="xfs filesystem utilities"
HOMEPAGE="http://oss.sgi.com/projects/xfs/"
SRC_URI="ftp://oss.sgi.com/projects/xfs/cmd_tars/${P}.tar.gz
	ftp://oss.sgi.com/projects/xfs/previous/cmd_tars/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="libedit nls readline static static-libs"
REQUIRED_USE="static? ( static-libs )"

LIB_DEPEND=">=sys-apps/util-linux-2.17.2[static-libs(+)]
	readline? ( sys-libs/readline[static-libs(+)] )
	!readline? ( libedit? ( dev-libs/libedit[static-libs(+)] ) )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	!<sys-fs/xfsdump-3"
DEPEND="${RDEPEND}
	static? (
		${LIB_DEPEND}
		readline? ( sys-libs/ncurses[static-libs] )
	)
	nls? ( sys-devel/gettext )"

pkg_setup() {
	if use readline && use libedit ; then
		ewarn "You have USE='readline libedit' but these are exclusive."
		ewarn "Defaulting to readline; please disable this USE flag if you want libedit."
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.2.2-sharedlibs.patch

	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:${PF}:" \
		include/builddefs.in || die
	sed -i \
		-e '1iLLDFLAGS = -static' \
		{estimate,fsr}/Makefile || die
	sed -i \
		-e "/LLDFLAGS/s:-static-libtool-libs:$(use static && echo -all-static):" \
		$(find -name Makefile) || die

	# libdisk has broken blkid conditional checking
	sed -i \
		-e '/LIB_SUBDIRS/s:libdisk::' \
		Makefile || die

	# TODO: write a patch for configure.in to use pkg-config for the uuid-part
	if use static && use readline ; then
		sed -i \
			-e 's|-lreadline|\0 -lncurses|' \
			-e 's|-lblkid|\0 -luuid|' \
			configure || die
	fi
}

src_configure() {
	export DEBUG=-DNDEBUG
	export OPTIMIZER=${CFLAGS}
	unset PLATFORM # if set in user env, this breaks configure

	local myconf
	if use static || use static-libs ; then
		myconf+=" --enable-static"
	else
		myconf+=" --disable-static"
	fi

	econf \
		--bindir=/usr/bin \
		--libexecdir=/usr/$(get_libdir) \
		$(use_enable nls gettext) \
		$(use_enable readline) \
		$(usex readline --disable-editline $(use_enable libedit editline)) \
		${myconf}

	MAKEOPTS+=" V=1"
}

src_install() {
	emake DIST_ROOT="${ED}" install
	# parallel install fails on these targets for >=xfsprogs-3.2.0
	emake -j1 DIST_ROOT="${ED}" install-{dev,qa}

	# handle is for xfsdump, the rest for xfsprogs
	gen_usr_ldscript -a xfs xlog
	# removing unnecessary .la files if not needed
	use static-libs || find "${ED}" -name '*.la' -delete
}

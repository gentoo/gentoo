# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs multilib

DESCRIPTION="xfs filesystem utilities"
HOMEPAGE="http://oss.sgi.com/projects/xfs/"
SRC_URI="ftp://ftp.kernel.org/pub/linux/utils/fs/xfs/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="libedit nls readline static static-libs"
REQUIRED_USE="static? ( static-libs )"

LIB_DEPEND=">=sys-apps/util-linux-2.17.2[static-libs(+)]
	readline? ( sys-libs/readline:0=[static-libs(+)] )
	!readline? ( libedit? ( dev-libs/libedit[static-libs(+)] ) )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	!<sys-fs/xfsdump-3"
DEPEND="${RDEPEND}
	static? (
		${LIB_DEPEND}
		readline? ( sys-libs/ncurses:0=[static-libs] )
	)
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.7.0-sharedlibs.patch
	"${FILESDIR}"/${PN}-4.7.0-libxcmd-link.patch
	"${FILESDIR}"/${PN}-4.9.0-cross-compile.patch
	"${FILESDIR}"/${P}-underlinking.patch
)

pkg_setup() {
	if use readline && use libedit ; then
		ewarn "You have USE='readline libedit' but these are exclusive."
		ewarn "Defaulting to readline; please disable this USE flag if you want libedit."
	fi
}

src_prepare() {
	epatch "${PATCHES[@]}"

	# LLDFLAGS is used for programs, so apply -all-static when USE=static is enabled.
	# Clear out -static from all flags since we want to link against dynamic xfs libs.
	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:${PF}:" \
		-e "1iLLDFLAGS += $(usex static '-all-static' '')" \
		include/builddefs.in || die
	find -name Makefile -exec \
		sed -i -r -e '/^LLDFLAGS [+]?= -static(-libtool-libs)?$/d' {} +

	# TODO: Write a patch for configure.ac to use pkg-config for the uuid-part.
	if use static && use readline ; then
		sed -i \
			-e 's|-lreadline|& -lncurses|' \
			-e 's|-lblkid|& -luuid|' \
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
		$(use_enable nls gettext) \
		$(use_enable readline) \
		$(usex readline --disable-editline $(use_enable libedit editline)) \
		${myconf}

	MAKEOPTS+=" V=1"
}

src_install() {
	emake DIST_ROOT="${ED}" install
	# parallel install fails on this target for >=xfsprogs-3.2.0
	emake -j1 DIST_ROOT="${ED}" install-dev

	# handle is for xfsdump, the rest for xfsprogs
	gen_usr_ldscript -a handle xcmd xfs xlog
	# removing unnecessary .la files if not needed
	use static-libs || find "${ED}" -name '*.la' -delete
}

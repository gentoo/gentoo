# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs systemd usr-ldscript

DESCRIPTION="xfs filesystem utilities"
HOMEPAGE="https://xfs.wiki.kernel.org/"
SRC_URI="https://www.kernel.org/pub/linux/utils/fs/xfs/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="icu libedit nls"

RDEPEND=">=sys-apps/util-linux-2.17.2
	dev-libs/inih
	icu? ( dev-libs/icu:= )
	libedit? ( dev-libs/libedit )
	!<sys-fs/xfsdump-3"
DEPEND="${RDEPEND}"
BDEPEND="
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.15.0-docdir.patch
	"${FILESDIR}"/${PN}-5.3.0-libdir.patch
)

src_prepare() {
	default

	# Fix doc dir
	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:${PF}:" \
		include/builddefs.in || die

	# Don't install compressed docs
	sed 's@\(CHANGES\)\.gz[[:space:]]@\1 @' -i doc/Makefile || die
}

src_configure() {
	# include/builddefs.in will add FCFLAGS to CFLAGS which will
	# unnecessarily clutter CFLAGS (and fortran isn't used)
	unset FCFLAGS

	export DEBUG=-DNDEBUG

	# Package is honoring CFLAGS; No need to use OPTIMIZER anymore.
	# However, we have to provide an empty value to avoid default
	# flags.
	export OPTIMIZER=" "

	unset PLATFORM # if set in user env, this breaks configure

	# Avoid automagic on libdevmapper, #709694
	export ac_cv_search_dm_task_create=no

	# Build fails with -O3 (bug #712698)
	replace-flags -O3 -O2

	# Upstream does NOT support --disable-static anymore,
	# https://www.spinics.net/lists/linux-xfs/msg30185.html
	# https://www.spinics.net/lists/linux-xfs/msg30272.html
	local myconf=(
		--enable-blkid
		--with-crond-dir="${EPREFIX}/etc/cron.d"
		--with-systemd-unit-dir="$(systemd_get_systemunitdir)"
		$(use_enable icu libicu)
		$(use_enable nls gettext)
		$(use_enable libedit editline)
	)

	if is-flagq -flto ; then
		myconf+=( --enable-lto )
	else
		myconf+=( --disable-lto )
	fi

	econf "${myconf[@]}"
}

src_compile() {
	emake V=1
}

src_install() {
	emake DIST_ROOT="${ED}" HAVE_ZIPPED_MANPAGES=false install
	emake DIST_ROOT="${ED}" HAVE_ZIPPED_MANPAGES=false install-dev

	gen_usr_ldscript -a handle
}

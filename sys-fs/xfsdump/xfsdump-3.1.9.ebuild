# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib flag-o-matic toolchain-funcs

DESCRIPTION="xfs dump/restore utilities"
HOMEPAGE="https://xfs.wiki.kernel.org/"
SRC_URI="https://www.kernel.org/pub/linux/utils/fs/xfs/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ~mips ppc ppc64 -sparc x86"
IUSE="ncurses nls"

RDEPEND="
	>=sys-apps/attr-2.4.19
	sys-apps/dmapi
	sys-apps/util-linux
	sys-fs/e2fsprogs
	>=sys-fs/xfsprogs-3.2.0
	ncurses? ( sys-libs/ncurses:0= )
"
DEPEND="${RDEPEND}
	nls? (
		sys-devel/gettext
		elibc_uclibc? ( dev-libs/libintl )
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.9-prompt-overflow.patch #335115
	"${FILESDIR}"/${PN}-3.1.9-no-symlink.patch #311881
	"${FILESDIR}"/${PN}-3.1.6-linguas.patch #561664
	"${FILESDIR}"/${PN}-3.1.9-fix-docs.patch
	"${FILESDIR}"/${PN}-3.1.9-skip-inventory-debian-subfolder.patch
)

src_prepare() {
	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:${PF}:" \
		include/builddefs.in \
		|| die
	sed -i \
		-e "s:enable_curses=[a-z]*:enable_curses=$(usex ncurses):" \
		-e "s:libcurses=\"[^\"]*\":libcurses='$(use ncurses && $(tc-getPKG_CONFIG) --libs ncurses)':" \
		configure || die #605852

	default
}

src_configure() {
	unset PLATFORM #184564
	export OPTIMIZER=${CFLAGS}
	export DEBUG=-DNDEBUG

	local myeconfargs=(
		$(use_enable nls gettext)
		--libdir="${EPREFIX}/$(get_libdir)"
		--libexecdir="${EPREFIX}/usr/$(get_libdir)"
		--sbindir="${EPREFIX}/sbin"
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# enable verbose build
	emake V=1
}

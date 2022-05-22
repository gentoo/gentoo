# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="xfs dump/restore utilities"
HOMEPAGE="https://xfs.wiki.kernel.org/"
SRC_URI="https://www.kernel.org/pub/linux/utils/fs/xfs/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 -sparc ~x86"
IUSE="ncurses nls"

RDEPEND=">=sys-apps/attr-2.4.19
	sys-apps/util-linux
	sys-fs/e2fsprogs
	>=sys-fs/xfsprogs-3.2.0
	ncurses? ( sys-libs/ncurses:= )"
DEPEND="${RDEPEND}
	nls? (
		sys-devel/gettext
	)"
BDEPEND="ncurses? ( virtual/pkgconfig )"

PATCHES=(
	# bug #335115
	"${FILESDIR}"/${PN}-3.1.9-prompt-overflow.patch
	# bug #311881
	"${FILESDIR}"/${PN}-3.1.9-no-symlink.patch
	# bug #561664
	"${FILESDIR}"/${PN}-3.1.6-linguas.patch

	"${FILESDIR}"/${PN}-3.1.9-fix-docs.patch
	"${FILESDIR}"/${PN}-3.1.9-skip-inventory-debian-subfolder.patch
)

src_prepare() {
	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:${PF}:" \
		include/builddefs.in \
		|| die

	# bug #605852
	sed -i \
		-e "s:enable_curses=[a-z]*:enable_curses=$(usex ncurses):" \
		-e "s:libcurses=\"[^\"]*\":libcurses='$(use ncurses && $(tc-getPKG_CONFIG) --libs ncurses)':" \
		configure || die

	default
}

src_configure() {
	# bug #184564
	unset PLATFORM

	export OPTIMIZER="${CFLAGS}"
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
	# Enable verbose build
	emake V=1
}

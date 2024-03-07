# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A set of tools that use the proc filesystem"
HOMEPAGE="http://psmisc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="apparmor nls selinux test X"
RESTRICT="!test? ( test )"

RDEPEND="
	!=app-i18n/man-pages-l10n-4.0.0-r0
	>=sys-libs/ncurses-5.7-r7:=
	apparmor? ( sys-libs/libapparmor )
	nls? ( virtual/libintl )
	selinux? ( sys-libs/libselinux )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/libtool-2.2.6b
	nls? ( sys-devel/gettext )
	test? ( dev-util/dejagnu )
"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	if tc-is-cross-compiler ; then
		# This isn't ideal but upstream don't provide a placement
		# when malloc is missing anyway, leading to errors like:
		# pslog.c:(.text.startup+0x108): undefined reference to `rpl_malloc'
		# See https://sourceforge.net/p/psmisc/bugs/71/
		# (and https://lists.gnu.org/archive/html/autoconf/2011-04/msg00019.html)
		export ac_cv_func_malloc_0_nonnull=yes \
			ac_cv_func_realloc_0_nonnull=yes
	fi

	local myeconfargs=(
		# Hardening flags are set by our toolchain alraedy. Setting these
		# in packages means toolchain & users can't set something tougher.
		--disable-harden-flags
		--enable-ipv6
		$(use_enable apparmor)
		$(use_enable nls)
		$(use_enable selinux)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	use X || rm -f "${ED}"/usr/bin/pstree.x11

	[[ -s ${ED}/usr/bin/peekfd ]] || rm -f "${ED}"/usr/bin/peekfd
	[[ -e ${ED}/usr/bin/peekfd ]] || rm -f "${ED}"/usr/share/man/man1/peekfd.1

	# fuser is needed by init.d scripts; use * wildcard for #458250
	dodir /bin
	mv "${ED}"/usr/bin/*fuser "${ED}"/bin || die
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic usr-ldscript

DESCRIPTION="standard informational utilities and process-handling tools"
HOMEPAGE="http://procps-ng.sourceforge.net/ https://gitlab.com/procps-ng/procps"
SRC_URI="mirror://sourceforge/${PN}-ng/${PN}-ng-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0/8" # libprocps.so
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="elogind +kill modern-top +ncurses nls selinux static-libs systemd test unicode"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	elogind? ( sys-auth/elogind )
	ncurses? ( >=sys-libs/ncurses-5.7-r7:=[unicode?] )
	selinux? ( sys-libs/libselinux )
	systemd? ( sys-apps/systemd )
"
DEPEND="${COMMON_DEPEND}
	elogind? ( virtual/pkgconfig )
	ncurses? ( virtual/pkgconfig )
	systemd? ( virtual/pkgconfig )
	test? ( dev-util/dejagnu )"
RDEPEND="
	${COMMON_DEPEND}
	kill? (
		!sys-apps/coreutils[kill]
		!sys-apps/util-linux[kill]
	)
	!<app-i18n/man-pages-de-2.12-r1
	!<app-i18n/man-pages-pl-0.7-r1
	!<sys-apps/sysvinit-2.88-r6
"

S="${WORKDIR}/${PN}-ng-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.11-sysctl-manpage.patch # 565304
	"${FILESDIR}"/${PN}-3.3.12-proc-tests.patch # 583036

	# Upstream fixes
)

src_configure() {
	# http://www.freelists.org/post/procps/PATCH-enable-transparent-large-file-support
	append-lfs-flags #471102
	local myeconfargs=(
		--docdir='$(datarootdir)'/doc/${PF}
		$(use_with elogind)
		$(use_enable kill)
		$(use_enable modern-top)
		$(use_with ncurses)
		$(use_enable nls)
		$(use_enable selinux libselinux)
		$(use_enable static-libs static)
		$(use_with systemd)
		$(use_enable unicode watch8bit)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	emake check </dev/null #461302
}

src_install() {
	default
	#dodoc sysctl.conf

	dodir /bin
	mv "${ED}"/usr/bin/ps "${ED}"/bin/ || die
	if use kill; then
		mv "${ED}"/usr/bin/kill "${ED}"/bin/ || die
	fi

	gen_usr_ldscript -a procps
	find "${ED}" -type f -name '*.la' -delete || die
}

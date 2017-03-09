# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="standard informational utilities and process-handling tools"
HOMEPAGE="http://procps-ng.sourceforge.net/ https://gitlab.com/procps-ng/procps"
SRC_URI="mirror://sourceforge/${PN}-ng/${PN}-ng-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0/5" # libprocps.so
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="+kill +ncurses modern-top nls selinux static-libs systemd test unicode"

RDEPEND="ncurses? ( >=sys-libs/ncurses-5.7-r7:=[unicode?] )
	selinux? ( sys-libs/libselinux )
	systemd? ( >=sys-apps/systemd-209 )"
DEPEND="${RDEPEND}
	ncurses? ( virtual/pkgconfig )
	systemd? ( virtual/pkgconfig )
	test? ( dev-util/dejagnu )"
RDEPEND+="
	kill? (
		!sys-apps/coreutils[kill]
		!sys-apps/util-linux[kill]
	)
	!<sys-apps/sysvinit-2.88-r6"

S="${WORKDIR}/${PN}-ng-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.8-kill-neg-pid.patch # http://crbug.com/255209
	"${FILESDIR}"/${PN}-3.3.11-sysctl-manpage.patch # 565304
	"${FILESDIR}"/${PN}-3.3.12-proc-tests.patch #583036

	# Upstream fixes
	"${FILESDIR}"/${P}-strtod_nol_err.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
	epatch_user
}

src_configure() {
	# http://www.freelists.org/post/procps/PATCH-enable-transparent-large-file-support
	append-lfs-flags #471102
	econf \
		--docdir='$(datarootdir)'/doc/${PF} \
		$(use_enable kill) \
		$(use_enable modern-top) \
		$(use_with ncurses) \
		$(use_enable nls) \
		$(use_enable selinux libselinux) \
		$(use_enable static-libs static) \
		$(use_with systemd) \
		$(use_enable unicode watch8bit)
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
	prune_libtool_files
}

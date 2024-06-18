# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="Standard informational utilities and process-handling tools"
HOMEPAGE="https://gitlab.com/procps-ng/procps"
# Per e.g. https://gitlab.com/procps-ng/procps/-/releases/v4.0.4, the dist tarballs
# are still hosted on SF.
SRC_URI="https://downloads.sourceforge.net/${PN}-ng/${PN}-ng-${PV}.tar.xz"
S="${WORKDIR}"/${PN}-ng-${PV}

# See bug #913210
LICENSE="GPL-2+ LGPL-2+ LGPL-2.1+"
SLOT="0/0-ng"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="elogind +kill modern-top +ncurses nls selinux static-libs systemd test unicode"
RESTRICT="!test? ( test )"

DEPEND="
	elogind? ( sys-auth/elogind )
	ncurses? ( >=sys-libs/ncurses-5.7-r7:=[unicode(+)?] )
	selinux? ( sys-libs/libselinux[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${DEPEND}
	!<app-i18n/man-pages-l10n-4.2.0-r1
	!<app-i18n/man-pages-de-2.12-r1
	!<app-i18n/man-pages-pl-0.7-r1
	kill? (
		!sys-apps/coreutils[kill]
		!sys-apps/util-linux[kill]
	)
"
BDEPEND="
	elogind? ( virtual/pkgconfig )
	ncurses? ( virtual/pkgconfig )
	systemd? ( virtual/pkgconfig )
	test? ( dev-util/dejagnu )
"

# https://bugs.gentoo.org/898830
QA_CONFIG_IMPL_DECL_SKIP=( makedev )

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.4-sysctl-manpage.patch # bug #565304
	"${FILESDIR}"/${PN}-4.0.4-fix-tests-multilib.patch
	"${FILESDIR}"/${PN}-4.0.4-xfail-pmap-test.patch
	"${FILESDIR}"/${P}-fix-systemd-linkage.patch
)

src_prepare() {
	default

	# Only for fix-tests-multilib.patch and fix-systemd-linkage.patch
	eautoreconf
}

multilib_src_configure() {
	# http://www.freelists.org/post/procps/PATCH-enable-transparent-large-file-support
	# bug #471102
	append-lfs-flags

	local myeconfargs=(
		# No elogind multilib support
		$(multilib_native_use_with elogind)
		$(multilib_native_use_enable kill)
		$(multilib_native_use_enable modern-top)
		$(multilib_native_enable pidof)
		$(multilib_native_use_with ncurses)
		# bug #794997
		$(multilib_native_use_enable !elibc_musl w)
		$(use_enable nls)
		$(use_enable selinux libselinux)
		$(use_enable static-libs static)
		$(use_with systemd)
	)

	if use ncurses; then
		# Only pass whis when we are building the 'watch' command
		myeconfargs+=( $(multilib_native_use_enable unicode watch8bit) )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	local ps="${BUILD_DIR}/src/ps/pscommand"
	if [[ $("${ps}" --no-headers -o cls -q $$) == IDL ]]; then
		# bug 708230
		ewarn "Skipping tests due to SCHED_IDLE"
	else
		# bug #461302
		emake check </dev/null
	fi
}

multilib_src_install() {
	default

	dodoc "${S}"/sysctl.conf

	if multilib_is_native_abi ; then
		dodir /bin
		mv "${ED}"/usr/bin/ps "${ED}"/bin/ || die
		if use kill ; then
			mv "${ED}"/usr/bin/kill "${ED}"/bin/ || die
		fi
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit flag-o-matic multilib-minimal multiprocessing

if [[ ${PV} == *9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/sandbox.git
		https://github.com/gentoo/sandbox.git"
else
	SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

DESCRIPTION="sandbox'd LD_PRELOAD hack"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Sandbox"

LICENSE="GPL-2"
SLOT="0"
IUSE="+nnp"

# pax-utils lower bound for bug #265376
DEPEND=">=app-misc/pax-utils-0.1.19"
# Avoid folks installing with older file, bug #889046. We still need the
# >= dep in Portage but this is a safety net if people do partial upgrades.
RDEPEND="!<sys-apps/file-5.44-r1"
BDEPEND="app-arch/xz-utils"

has sandbox_death_notice ${EBUILD_DEATH_HOOKS} || EBUILD_DEATH_HOOKS+=" sandbox_death_notice"

sandbox_death_notice() {
	ewarn "If configure failed with a 'cannot run C compiled programs' error, try this:"
	ewarn "FEATURES='-sandbox -usersandbox' emerge sandbox"
}

src_prepare() {
	default

	if [[ ${PV} == *9999 ]]; then
		eautoreconf
	fi

	if ! use nnp ; then
		sed -i 's:PR_SET_NO_NEW_PRIVS:___disable_nnp_hack:' src/sandbox.c || die
	fi
}

src_configure() {
	# sandbox uses `__asm__ (".symver "...` which does
	# not play well with gcc's LTO: https://gcc.gnu.org/PR48200
	filter-lto

	filter-lfs-flags #90228

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local ECONF_SOURCE="${S}"
	econf
}

multilib_src_test() {
	# Default sandbox build will run with --jobs set to # cpus.
	emake check TESTSUITEFLAGS="--jobs=$(makeopts_jobs)"
}

multilib_src_install_all() {
	doenvd "${FILESDIR}"/09sandbox

	dodoc AUTHORS ChangeLog* README.md
}

pkg_postinst() {
	mkdir -p "${EROOT}"/var/log/sandbox
	chown root:portage "${EROOT}"/var/log/sandbox
	chmod 0770 "${EROOT}"/var/log/sandbox
}

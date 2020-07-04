# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot flag-o-matic toolchain-funcs vcs-snapshot

MY_SNAPSHOT="${PN}-9277bfd433e398d0a6eabec79edead52d4cb8125"

DESCRIPTION="SPARC/UltraSPARC Improved Loader, a boot loader for sparc"
SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/davem/silo.git/snapshot/${MY_SNAPSHOT}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://git.kernel.org/?p=linux/kernel/git/davem/silo.git;a=summary"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* ~sparc"
IUSE="tilo-only"

DEPEND="sys-fs/e2fsprogs
	sys-apps/sparc-utils"
RDEPEND=""

src_prepare() {
	default

	# Set the correct version
	sed -i -e "s/1.4.14/1.4.14_git20200602/g" Rules.make || die

	# Fix build failure
	sed -i -e "s/-fno-strict-aliasing/-fno-strict-aliasing -mcpu=v9/g" Rules.make || die

	# Don't strip ieee32.b during compile
	sed -i -e '/^	$(STRIP) ieee32.b/d' first/Makefile || die
}

src_compile() {
	filter-flags "-fstack-protector"

	CC="$(tc-getCC)" \
	STRIP="$(tc-getSTRIP)" \
	NM="$(tc-getNM)" \
	LD="$(tc-getLD)" \
		emake $(usex tilo-only '-C tilo' '')
}

src_install() {
	default

	dodoc first-isofs/README.SILO_ISOFS docs/README*

	# Fix maketilo manpage
	rm "${D}"/usr/share/man/man1/maketilo.1
	dosym tilo.1 /usr/share/man/man1/maketilo.1
}

pkg_postinst() {
	use tilo-only && return

	mount-boot_pkg_postinst
	ewarn "NOTE: If this is an upgrade to an existing SILO install,"
	ewarn "      you will need to re-run silo as the /boot/second.b"
	ewarn "      file has changed, else the system will fail to load"
	ewarn "      SILO at the next boot."
	ewarn
}

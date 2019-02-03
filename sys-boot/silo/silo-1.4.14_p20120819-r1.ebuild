# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mount-boot flag-o-matic toolchain-funcs eutils

DEB_PL="1"
MY_PV="${PV##*_p}"
MY_GIT="git${MY_PV%%_*}"
MY_PV="${PV%%_*}"
MY_P="${PN}_${MY_PV}+${MY_GIT}"

DESCRIPTION="SPARC/UltraSPARC Improved Loader, a boot loader for sparc"
SRC_URI="mirror://debian/pool/main/s/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/s/${PN}/${MY_P}-${DEB_PL}.diff.gz"
HOMEPAGE="https://git.kernel.org/?p=linux/kernel/git/davem/silo.git;a=summary"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* sparc"
IUSE=""

DEPEND="sys-fs/e2fsprogs
	sys-apps/sparc-utils"
RDEPEND=""

ABI_ALLOW="sparc32"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${P}-gnu90-inline.patch
)

src_prepare() {
	default

	#Set the correct version
	sed -i -e "s/1.4.14/1.4.14_git20120819_p1/g" Rules.make || die

	# Fix build failure
	# -fno-PIC is needed to shrink silo size back to manageable on
	# profiles where gcc has -fPIC default (via --enable-default-pie).
	sed -i -e "s/-fno-strict-aliasing/-fno-strict-aliasing -U_FORTIFY_SOURCE -mcpu=v9 -fno-PIC/g" Rules.make || die
}

src_compile() {
	filter-flags "-fstack-protector"

	emake CC="$(tc-getCC)"
}

src_install() {
	default

	dodoc first-isofs/README.SILO_ISOFS docs/README*

	# Fix maketilo manpage
	rm "${D}"/usr/share/man/man1/maketilo.1
	dosym tilo.1 /usr/share/man/man1/maketilo.1
}

pkg_postinst() {
	mount-boot_pkg_postinst
	ewarn "NOTE: If this is an upgrade to an existing SILO install,"
	ewarn "      you will need to re-run silo as the /boot/second.b"
	ewarn "      file has changed, else the system will fail to load"
	ewarn "      SILO at the next boot."
	ewarn
}

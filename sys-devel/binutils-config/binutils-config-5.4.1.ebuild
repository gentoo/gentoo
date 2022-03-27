# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/binutils-config.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

DESCRIPTION="Utility to change the binutils version being used"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Toolchain"

LICENSE="GPL-2"
SLOT="0"
IUSE="+native-symlinks"

# We also RDEPEND on sys-apps/findutils which is in base @system
RDEPEND="sys-apps/gentoo-functions"

src_compile() {
	emake PV="${PV}" USE_NATIVE_LINKS="$(usex native-symlinks)"
}

src_install() {
	emake DESTDIR="${D}" PV="${PV}" install

	use prefix && eprefixify "${ED}"/usr/bin/${PN}
}

pkg_postinst() {
	# Re-register all targets. USE flags or new versions can change
	# installed symlinks.
	local x
	for x in $(binutils-config -C -l 2>/dev/null | awk '$NF == "*" { print $2 }') ; do
		binutils-config ${x}
	done
}

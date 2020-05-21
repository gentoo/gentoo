# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/binutils-config.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~slyfox/distfiles/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
fi

DESCRIPTION="Utility to change the binutils version being used"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Toolchain"

LICENSE="GPL-2"
SLOT="0"
IUSE="+native-symlinks"

# We also RDEPEND on sys-apps/findutils which is in base @system
RDEPEND="sys-apps/gentoo-functions"

src_compile() {
	emake DESTDIR="${D}" PV="${PV}" USE_NATIVE_LINKS="$(usex native-symlinks)"
}

src_install() {
	emake DESTDIR="${D}" PV="${PV}" install

	use prefix && eprefixify "${ED}"/usr/bin/${PN}
}

pkg_preinst() {
	# Force a refresh when upgrading from an older version that symlinked
	# in all the libs & includes that binutils-libs handles. #528088
	if has_version "<${CATEGORY}/${PN}-5" ; then
		local bc current
		bc="${ED}/usr/bin/binutils-config"
		if current=$("${bc}" -c) ; then
			"${bc}" "${current}"
		fi
	fi
}

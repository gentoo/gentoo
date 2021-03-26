# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gcc-config.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~slyfox/distfiles/${P}.tar.xz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86"
fi

DESCRIPTION="Utility to manage compilers"
HOMEPAGE="https://gitweb.gentoo.org/proj/gcc-config.git/"
LICENSE="GPL-2"
SLOT="0"
IUSE="+cc-wrappers +native-symlinks"

RDEPEND=">=sys-apps/gentoo-functions-0.10"

_emake() {
	emake \
		PV="${PVR}" \
		SUBLIBDIR="$(get_libdir)" \
		USE_CC_WRAPPERS="$(usex cc-wrappers)" \
		USE_NATIVE_LINKS="$(usex native-symlinks)" \
		TOOLCHAIN_PREFIX="${CHOST}-" \
		"$@"
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${D}" install
}

pkg_postinst() {
	# Do we have a valid multi ver setup ?
	local x
	for x in $(gcc-config -C -l 2>/dev/null | awk '$NF == "*" { print $2 }') ; do
		gcc-config ${x}
	done

	# USE flag change can add or delete files in /usr/bin worth recaching
	if [[ ! ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow update all
	fi
}

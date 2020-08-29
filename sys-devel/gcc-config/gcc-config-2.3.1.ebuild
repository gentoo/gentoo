# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gcc-config.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~slyfox/distfiles/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

DESCRIPTION="Utility to manage compilers"
HOMEPAGE="https://gitweb.gentoo.org/proj/gcc-config.git/"
LICENSE="GPL-2"
SLOT="0"
IUSE="+native-symlinks"

RDEPEND=">=sys-apps/gentoo-functions-0.10"

_emake() {
	emake \
		PV="${PV}" \
		SUBLIBDIR="$(get_libdir)" \
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

maybe_remove_old_wrappers() {
	if ! has collision-protect ${FEATURES}; then
		# Don't bother if we'll just overwrite any old wrapper(s) anyway
		return
	fi
	local replacing delete_old_wrappers=true
	for replacing in ${REPLACING_VERSIONS}; do
		if ver_test $OLD_VER -ge '2.3.1'; then
			delete_old_wrappers=false
			break
		fi
	done
	if $delete_old_wrappers; then
		# Check that the existing files are in fact the old wrappers expected
		sha256sum --check --status &>/dev/null <<\EOF
29ad5dd697135c2892067e780447894dc1cd071708157e46d21773ab99c5022c  /usr/bin/c89
057b348cf5be9b4fb9db99a4549f6433c89d21e5f91dc5e46b0b4dc6b70432f5  /usr/bin/c99
EOF
		if [ $? = 1 ]; then
			# Files did NOT match (let collision protect deal with any complaint later)
			delete_old_wrappers=false
		fi
	fi
	if $delete_old_wrappers; then
		einfo "Deleting old /usr/bin/c?9 wrapper scripts (to be replaced by ${P})"
		rm -f /usr/bin/{c89,c99}
	fi
}

pkg_preinst() {
	maybe_remove_old_wrappers
}

pkg_postinst() {
	# Scrub eselect-compiler remains.
	# To be removed in 2021.
	rm -f "${ROOT}"/etc/env.d/05compiler

	# We not longer use the /usr/include/g++-v3 hacks, as
	# it is not needed ...
	# To be removed in 2021.
	rm -f "${ROOT}"/usr/include/g++{,-v3}

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

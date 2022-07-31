# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: if bumping pax-utils because of syscall changes in glibc, please
# revbump glibc and update the dependency in its ebuild for the affected
# versions.
PYTHON_COMPAT=( python3_{8..11} )

inherit meson python-single-r1

DESCRIPTION="ELF utils that can check files for security relevant properties"
HOMEPAGE="https://wiki.gentoo.org/index.php?title=Project:Hardened/PaX_Utilities"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/pax-utils.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz
		https://dev.gentoo.org/~vapier/dist/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="caps +man python seccomp test"

_PYTHON_DEPS="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pyelftools[${PYTHON_USEDEP}]
	')
"

RDEPEND="caps? ( >=sys-libs/libcap-2.24 )
	python? ( ${_PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	caps? ( virtual/pkgconfig )
	man? ( app-text/xmlto )

	python? ( ${_PYTHON_DEPS} )
"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( python )
"
RESTRICT="
	!test? ( test )
"

pkg_setup() {
	if use test || use python; then
		python-single-r1_pkg_setup
	fi
}

src_configure() {
	local emesonargs=(
		"-Dlddtree_implementation=$(usex python python sh)"
		$(meson_feature caps use_libcap)
		$(meson_feature man build_manpages)
		$(meson_use seccomp use_seccomp)
		$(meson_use test tests)

		# fuzzing is currently broken
		-Duse_fuzzing=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	use python && python_fix_shebang "${ED}"/usr/bin/lddtree
}

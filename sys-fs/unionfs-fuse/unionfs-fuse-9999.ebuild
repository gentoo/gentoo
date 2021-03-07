# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )
inherit python-any-r1 toolchain-funcs

DESCRIPTION="Self-syncing tree-merging file system based on FUSE"
HOMEPAGE="https://github.com/rpodgorny/unionfs-fuse"
EGIT_REPO_URI="https://github.com/rpodgorny/unionfs-fuse.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-fs/fuse:0"
DEPEND="${RDEPEND}
	test? (
		$(python_gen_any_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

python_check_deps() {
	use test || return 0
	has_version "dev-python/pytest[${PYTHON_USEDEP}]"
}

src_compile() {
	emake AR="$(tc-getAR)" CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}

src_test() {
	[[ -e /dev/fuse ]] || return 0
	addwrite /dev/fuse
	pytest -vv || die "Tests fail with ${EPYTHON}"
}

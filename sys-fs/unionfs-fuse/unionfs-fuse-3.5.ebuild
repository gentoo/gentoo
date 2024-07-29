# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{9..12} )
inherit python-any-r1 toolchain-funcs

DESCRIPTION="Self-syncing tree-merging file system based on FUSE"
HOMEPAGE="https://github.com/rpodgorny/unionfs-fuse"
SRC_URI="https://github.com/rpodgorny/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-fs/fuse:3"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		$(python_gen_any_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/pytest[${PYTHON_USEDEP}]"
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

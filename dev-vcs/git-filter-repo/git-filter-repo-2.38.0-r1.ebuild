# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Quickly rewrite git repository history (filter-branch replacement)"
HOMEPAGE="https://github.com/newren/git-filter-repo/"
SRC_URI="https://github.com/newren/git-filter-repo/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-vcs/git-$(ver_cut 1-2)
"

S="${S}/release"

python_prepare_all() {
	cat > PKG-INFO <<-EOF || die
	Metadata-Version: 2.1
	Name: git-filter-repo
	Version: ${PV}
	EOF

	distutils-r1_python_prepare_all
}

python_test() {
	cd .. || die
	bash t/run_tests || die
}

python_install_all() {
	distutils-r1_python_install_all

	# Points to dead symlink
	rm "${ED}"/usr/share/doc/${PF}/README.md || die
	rmdir "${ED}"/usr/share/doc/${PF} || die

	dodoc "${WORKDIR}"/${P}/README.md
}

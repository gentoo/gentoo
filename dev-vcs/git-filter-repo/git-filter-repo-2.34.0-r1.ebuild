# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1

DESCRIPTION="Quickly rewrite git repository history (filter-branch replacement)"
HOMEPAGE="https://github.com/newren/git-filter-repo/"
SRC_URI="
	https://github.com/newren/git-filter-repo/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	>=dev-vcs/git-2.24.0"

S="${S}/release"

src_prepare() {
	eapply_user
	cat > PKG-INFO <<EOF
Metadata-Version: 2.1
Name: git-filter-repo
Version: ${PV}
EOF
}

src_test() {
	bash t/run_tests || die
}

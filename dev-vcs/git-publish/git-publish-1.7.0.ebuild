# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit python-single-r1

DESCRIPTION="Tool for preparing and storing patch revisions as git tag"
HOMEPAGE="https://github.com/stefanha/git-publish"
SRC_URI="https://github.com/stefanha/git-publish/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+man"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-vcs/git
"
BDEPEND="${PYTHON_DEPS}
	man? ( dev-lang/perl )
"

src_prepare() {
	default
	python_fix_shebang git-publish
}

src_compile() {
	if use man; then
		pod2man --center "git-publish Documentation" --release "${PV}" \
			git-publish.pod git-publish.1 || die
	fi
}

src_install() {
	dobin git-publish
	use man && doman git-publish.1
	insinto /usr/share/${PN}/hooks
	doins hooks/pre-publish-send-email.example
}

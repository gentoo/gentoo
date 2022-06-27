# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=9d5dc2ffa1e4c7b43734b03dccb5ae6a80800569
NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Highlight uncommitted changes, jump between and revert them selectively"
HOMEPAGE="https://github.com/dgutov/diff-hl/"
SRC_URI="https://github.com/dgutov/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-vcs/git )"

DOCS=( README.md screenshot.png screenshot-dired.png screenshot-margin.png )
ELISP_REMOVE=( .dir-locals.el )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	ebegin "Creating a git repository for tests"
	git init "${S}" --initial-branch="master" &&
		git add "${S}" &&
		git config --local user.email "test@test" &&
		git config --local user.name "test" &&
		git commit --message "test" --quiet
	eend $? || die
	emake EMACS="${EMACS} ${EMACSFLAGS}" test
}

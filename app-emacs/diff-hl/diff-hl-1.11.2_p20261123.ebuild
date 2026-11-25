# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Highlight uncommitted changes, jump between and revert them selectively"
HOMEPAGE="https://github.com/dgutov/diff-hl/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dgutov/${PN}.git"
else
	[[ "${PV}" == *p20261123 ]] && COMMIT=768b8f16943a85e096930ac0b5982ef681fcef30
	SRC_URI="https://github.com/dgutov/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.snapshot.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-vcs/git
	)
"

DOCS=( README.md screenshot{,-dired,-margin}.png )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	# Remove broken tests
	sed -i \
		-e "s|(diff-hl-deftest diff-hl-indirect-buffer-move-async|'&|g" \
		-e "s|(diff-hl-deftest diff-hl-resolved-revision-with-hg|'&|g" \
		test/diff-hl-test.el \
		|| die

	default
}

src_test() {
	ebegin "Creating a git repository for tests"
	git init "${S}" --initial-branch="master" &&
		git add "${S}" &&
		git config --local user.email "test@test" &&
		git config --local user.name "test" &&
		git commit --message "test" --quiet
	eend "${?}" || die

	emake EMACS="${EMACS} ${EMACSFLAGS}" test
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Quickly reference files in Git using numbers"
HOMEPAGE="https://github.com/schreifels/git-num"
SRC_URI="https://github.com/schreifels/git-num/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND+=" test? ( dev-vcs/git )"
RDEPEND+=" dev-vcs/git"

all_ruby_prepare() {
	# cp git-num since specs depend on the default location
	mkdir bin || die
	cp git-num bin || die

	sed -i -e '14i`git config user.email "test-git-num@gentoo.org"`' \
		-e '15i`git config user.name "git-num tester"`' spec/lib/git_tools.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec spec/unit.rb spec/integration.rb
}

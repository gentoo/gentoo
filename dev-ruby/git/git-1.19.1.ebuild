# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="git.gemspec"

inherit ruby-fakegem

DESCRIPTION="Library for using Git in Ruby"
HOMEPAGE="https://github.com/ruby-git/ruby-git"
SRC_URI="https://github.com/ruby-git/ruby-git/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="ruby-git-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

DEPEND+="test? ( >=dev-vcs/git-1.6.0.0 app-arch/tar )"
RDEPEND+=">=dev-vcs/git-1.6.0.0"

ruby_add_rdepend ">=dev-ruby/addressable-2.8:0 >=dev-ruby/rchardet-1.8:1"

ruby_add_bdepend "test? ( dev-ruby/bundler dev-ruby/minitar >=dev-ruby/mocha-2.1:2 dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	# Don't use hardcoded /tmp directory.
	sed -i -e "s:/tmp:${TMPDIR}:" tests/units/test_archive.rb tests/test_helper.rb || die

	sed -i -e 's/__dir__/"."/' -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Don't use deprecated key type that is removed from openssh
	sed -i -e 's/-t dsa/-t rsa/' tests/units/test_signed_commits.rb || die
}

each_ruby_test() {
	git config --global user.email "git@example.com" || die
	git config --global user.name "GitExample" || die
	${RUBY} -Ilib:.:tests -e 'Dir["tests/**/test_*.rb"].each {|f| require f}' || die
}

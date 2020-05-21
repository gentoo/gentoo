# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="git.gemspec"

inherit ruby-fakegem

DESCRIPTION="Library for using Git in Ruby"
HOMEPAGE="https://github.com/schacon/ruby-git"
SRC_URI="https://github.com/schacon/ruby-git/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="ruby-git-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND+="test? ( >=dev-vcs/git-1.6.0.0 app-arch/tar )"
RDEPEND+=">=dev-vcs/git-1.6.0.0"

ruby_add_rdepend ">=dev-ruby/rchardet-1.8:1"

ruby_add_bdepend "test? ( dev-ruby/bundler dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	# Don't use hardcoded /tmp directory.
	sed -i -e "s:/tmp:${TMPDIR}:" tests/units/test_archive.rb tests/test_helper.rb || die
}

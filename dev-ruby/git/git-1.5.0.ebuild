# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="git.gemspec"

inherit ruby-fakegem

DESCRIPTION="Library for using Git in Ruby"
HOMEPAGE="https://github.com/schacon/ruby-git"
SRC_URI="https://github.com/schacon/ruby-git/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="ruby-git-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

DEPEND+="test? ( >=dev-vcs/git-1.6.0.0 app-arch/tar )"
RDEPEND+=">=dev-vcs/git-1.6.0.0"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	# Don't use hardcoded /tmp directory.
	sed -i -e "s:/tmp:${TMPDIR}:" tests/units/test_archive.rb tests/test_helper.rb || die
}

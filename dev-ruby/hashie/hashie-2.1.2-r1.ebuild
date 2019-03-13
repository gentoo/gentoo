# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Hashie is a small collection of tools that make hashes more powerful"
HOMEPAGE="http://intridea.com/posts/hashie-the-hash-toolkit"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE=""

all_ruby_prepare() {
	# Remove bundler and fix one spec that depends on its requires
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -e '2irequire "hashie/version"' -i spec/hashie/version_spec.rb || die
}

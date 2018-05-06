# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.md"

RUBY_FAKEGEM_GEMSPEC="arel.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="Arel is a Relational Algebra for Ruby"
HOMEPAGE="https://github.com/rails/arel"
SRC_URI="https://github.com/rails/arel/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="$(get_version_component_range 1).0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	test? (
		dev-ruby/concurrent-ruby:1
		dev-ruby/test-unit:2
		>=dev-ruby/minitest-5.4:5
	)"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" \
		-e '/specname/,$ s:^:#:' Rakefile || die
}

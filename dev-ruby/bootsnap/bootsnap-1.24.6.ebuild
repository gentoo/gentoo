# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_GEMSPEC="bootsnap.gemspec"

RUBY_FAKEGEM_BINDIR="exe"

RUBY_FAKEGEM_EXTENSIONS=( ext/bootsnap/extconf.rb )
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/bootsnap"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit edo ruby-fakegem

DESCRIPTION="Boot large ruby/rails apps faster"
HOMEPAGE="https://github.com/rails/bootsnap"
SRC_URI="https://github.com/rails/bootsnap/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend "
	>=dev-ruby/msgpack-1.2
"
ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		dev-ruby/minitest:5
		>=dev-ruby/mocha-3
	)
"

all_ruby_prepare() {
	sed -e 's:`git ls-files -z \(.*\)`:`find \1 -print0`:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -e '/rubocop/ s:^:#:' \
		-e '/rake-compiler/ s:^:#:' \
		-i Gemfile || die

	sed -e '/rake\/extensiontask/ s:^:#:' \
		-e '/Rake::ExtensionTask/,/^end/ s:^:#:' \
		-i Rakefile || die
}

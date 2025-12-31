# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/skiptrace/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/skiptrace/internal"

inherit ruby-fakegem

DESCRIPTION="Bindings for your Ruby exceptions"
HOMEPAGE="https://github.com/gsamokovarov/bindex"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

all_ruby_prepare() {
	sed -e '/bundler/I s:^:#:' \
		-e '/when/ s/ruby/rubyx/' \
		-i Rakefile || die

	# Fix minitest deprecation
	sed -e 's/MiniTest/Minitest/' \
		-i test/test_helper.rb || die
}

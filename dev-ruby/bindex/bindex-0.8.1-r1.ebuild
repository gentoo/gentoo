# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/skiptrace/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/skiptrace/internal"

inherit ruby-fakegem

DESCRIPTION="Bindings for your Ruby exceptions"
HOMEPAGE="https://github.com/gsamokovarov/bindex"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -e '/bundler/I s:^:#:' \
		-e '/when/ s/ruby/rubyx/' \
		-i Rakefile || die
}

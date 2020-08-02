# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

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

each_ruby_configure() {
	${RUBY} -Cext/skiptrace extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/skiptrace
	cp ext/skiptrace/cruby.so lib/skiptrace/internal/ || die
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

GITHUB_USER="mongodb"
GITHUB_PROJECT="bson-ruby"

inherit multilib ruby-fakegem

DESCRIPTION="A Ruby BSON implementation for MongoDB. (Includes binary C-based extension.)"
HOMEPAGE="https://www.mongodb.org/"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="bson-ruby-${PV}"

LICENSE="APSL-2"
SLOT="4"
KEYWORDS="~amd64"
IUSE="test doc"

all_ruby_prepare() {
	# Remove bundler support
	sed -i -e '/bundler/I s:^:#:' Rakefile || die

	# Remove project-specific rspec options
	rm .rspec || die
}

each_ruby_configure() {
	${RUBY} -C ext/bson extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -C ext/bson V=1 CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}"
	cp ext/bson/*$(get_modname) lib/ || die
}

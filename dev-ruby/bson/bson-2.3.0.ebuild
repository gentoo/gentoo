# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
# jruby → support needs to be written properly
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

GITHUB_USER="mongodb"
GITHUB_PROJECT="bson-ruby"

inherit multilib ruby-fakegem

DESCRIPTION="A Ruby BSON implementation for MongoDB. (Includes binary C-based extension.)"
HOMEPAGE="http://www.mongodb.org/"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="bson-ruby-${PV}"

LICENSE="APSL-2"
SLOT="2"
KEYWORDS="~amd64"
IUSE="test doc"

ruby_add_bdepend \
	"test? (
		dev-ruby/rake
		dev-ruby/shoulda
		dev-ruby/mocha
		dev-ruby/test-unit:2
	)
	doc? ( dev-ruby/rdoc )"

all_ruby_prepare() {
	# Remove bundler support
	sed -i -e '/bundler/I s:^:#:' Rakefile || die

	# Remove project-specific rspec options
	rm .rspec || die
}

each_ruby_configure() {
	case ${RUBY} in
		*/ruby19|*/ruby20|*/ruby21|*/ruby22)
			${RUBY} -C ext/bson extconf.rb || die "extconf.rb failed"
			;;
		*/jruby)
			${RUBY} -S rake build:java || die "rake build:java failed"
			;;
	esac
}

each_ruby_compile() {
	case ${RUBY} in
		*/ruby19|*/ruby20|*/ruby21|*/ruby22)
			emake -C ext/bson V=1 CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}"
			cp ext/bson/*$(get_modname) lib/ || die
			;;
		*/jruby)
			die "missing in ebuild"
			;;
	esac
}

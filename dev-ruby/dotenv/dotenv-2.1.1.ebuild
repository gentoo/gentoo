# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="README.md Changelog.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Loads environment variables from .env into ENV"
HOMEPAGE="https://github.com/bkeepers/dotenv"
SRC_URI="https://github.com/bkeepers/dotenv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="2"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/spring dev-ruby/rails )"

all_ruby_prepare() {
	sed -i -e '/:guard/,/end/ s:^:#:' \
		-e '5igem "rspec", "~> 3.0"' Gemfile || die

	sed -i -e '/rubocop/ s:^:#:' dotenv.gemspec || die
}

each_ruby_prepare() {
	sed -i -e "s:ruby -v:${RUBY} -v:g" spec/dotenv/parser_spec.rb || die
}

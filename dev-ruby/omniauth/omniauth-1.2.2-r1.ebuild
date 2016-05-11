# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_DOCDIR="doc"

inherit ruby-fakegem

DESCRIPTION="A generalized Rack framework for multiple-provider authentication"
HOMEPAGE="https://github.com/intridea/omniauth"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend "dev-ruby/rack dev-ruby/hashie"
ruby_add_bdepend "doc? ( dev-ruby/yard )
	test? ( dev-ruby/rack-test )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' \
		Rakefile ${PN}.gemspec || die "sed failed"
	sed -i -e '/simplecov/,/^end/ s:^:#:' spec/helper.rb || die "sed failed"
	# maruku fails, resorting to default markdown implementation
	sed -i -e '/maruku/d' .yardopts || die "sed failed"
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc ; then
		yard || die "yard failed"
	fi
}

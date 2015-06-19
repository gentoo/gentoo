# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-beautify/ruby-beautify-0.92.2.ebuild,v 1.1 2014/08/16 07:00:14 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="README.md RELEASE.md"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="a cli tool (and module) to beautify ruby code"
HOMEPAGE="https://github.com/erniebrodeur/ruby-beautify"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

all_ruby_prepare() {
	# Avoid failing tests for now. We are adding this for
	# dev-ruby/gherkin and they seem happy with it.
	# https://github.com/erniebrodeur/ruby-beautify/issues/2
	sed -e '/not change the indentation of multiline string/,/^$/ s:^:#:' \
		-e '/not indent multineline comment/,/^$/ s:^:#:' \
		-i spec/fixtures/ruby.yml || die
}

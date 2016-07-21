# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="README.md WHATSNEW.md"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="a cli tool (and module) to beautify ruby code"
HOMEPAGE="https://github.com/erniebrodeur/ruby-beautify"
LICENSE="MIT"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc64 ~x86"
SLOT="0"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/codeclimate/I s:^:#:' spec/spec_helper.rb || die
}

each_ruby_prepare() {
	# Needed for specs
	mkdir tmp || die

	# Use correct ruby interpreter to test and avoid bundler. Handle
	# directory changes.
	sed -i -e 's|bundle exec|'${RUBY}' -Ilib:../lib -S|' spec/bin/ruby-beautify_spec.rb || die
}

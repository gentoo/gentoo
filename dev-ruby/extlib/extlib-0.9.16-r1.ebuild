# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ruby21 → fails specs.
USE_RUBY="ruby20"

RUBY_FAKEGEM_TASK_DOC="-f tasks/yard.rake yard"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_GEMSPEC=${PN}.gemspec

inherit ruby-fakegem

DESCRIPTION="Support library for DataMapper and Merb"
HOMEPAGE="http://extlib.rubyforge.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_bdepend "
	doc? ( dev-ruby/yard )
	test? ( >=dev-ruby/json-1.4.0 )"

all_ruby_prepare() {
	sed -i -e '/spec/d' spec/spec_helper.rb || die

	# We always use json.
	sed -i -e 's/json_pure/json/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

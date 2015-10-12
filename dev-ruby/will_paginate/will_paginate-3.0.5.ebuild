# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Most awesome pagination solution for Ruby"
HOMEPAGE="https://github.com/mislav/will_paginate/"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE=""

ruby_add_bdepend "
	test? (
		=dev-ruby/rails-3*
		dev-ruby/mocha
	)"

all_ruby_prepare() {
	sed -e '1igem "rails", "~> 3.2.0"' -i spec/spec_helper.rb || die
}

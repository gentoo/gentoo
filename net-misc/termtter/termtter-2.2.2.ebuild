# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19"
#RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_TEST=""
RUBY_FAKEGEM_TASK_TEST="spec"

inherit ruby-fakegem

DESCRIPTION="Termtter is a terminal based Twitter client"
HOMEPAGE="https://github.com/termtter/termtter"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/json
	dev-ruby/highline
	dev-ruby/termcolor
	dev-ruby/rubytter
	dev-ruby/notify
	dev-ruby/activerecord
	dev-ruby/builder"
#	dev-ruby/fluent-logger
ruby_add_bdepend "
	doc? ( dev-ruby/rdoc )
	test? (
		dev-ruby/haml
		dev-ruby/git
		dev-ruby/rspec
		dev-ruby/jeweler
	)"
#	dev-ruby/cucumber

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.markdown examples.rb"

RUBY_FAKEGEM_EXTRAINSTALL="init.rb"

inherit ruby-fakegem eutils

DESCRIPTION="Log statements along with their name easily"
HOMEPAGE="https://github.com/relevance/log_buddy"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? ( >=dev-ruby/mocha-0.9 )"

all_ruby_prepare() {
	rm Gemfile || die
}

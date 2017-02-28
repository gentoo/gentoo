# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Extends Rake with remote task goodness"
HOMEPAGE="https://github.com/seattlerb/rake-remote_task"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend ">=dev-ruby/hoe-2.9.2
	test? ( dev-ruby/minitest )"
ruby_add_rdepend ">=dev-ruby/open4-1.0 >=dev-ruby/rake-0.8 <dev-ruby/rake-12"

all_ruby_prepare() {
	sed -i -e '/isolate/ s:^:#:' Rakefile || die
}

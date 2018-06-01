# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit ruby-fakegem

DESCRIPTION="A simple, flexible, extensible, and liberal RSS and Atom reader for Ruby"
HOMEPAGE="http://simple-rss.rubyforge.org/"
LICENSE="LGPL-2"

KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/rspec )"

all_ruby_prepare() {
	# Avoid dependency on bundler
	sed -i -e '/bundler/d' \
		-e '/rubyforgepublisher/I s:^:#:' \
		Rakefile || die

	# https://github.com/cardmagic/simple-rss/pull/14
	sed -i -e 's/README/README.markdown/' Rakefile || die
}

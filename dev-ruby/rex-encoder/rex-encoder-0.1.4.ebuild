# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

# Specs are not provided in the gem
RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="provides the basis for all of the polymorphic encoders that Metasploit uses"
HOMEPAGE="https://rubygems.org/gems/rex-encoder"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
RESTRICT="test"

ruby_add_rdepend "dev-ruby/metasm:*
					dev-ruby/rex-arch
					dev-ruby/rex-text"

all_ruby_prepare() {
	sed -i '/bundler/d' Rakefile
}

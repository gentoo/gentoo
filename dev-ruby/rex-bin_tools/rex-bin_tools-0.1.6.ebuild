# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="suite of tools for analyzing executables to find specific chunks of code"
HOMEPAGE="https://rubygems.org/gems/rex-bin_tools"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/rex-arch
					dev-ruby/metasm:*
					dev-ruby/rex-core
					dev-ruby/rex-struct2
					dev-ruby/rex-text"

all_ruby_prepare() {
	sed -i '/bundler/d' Rakefile
}

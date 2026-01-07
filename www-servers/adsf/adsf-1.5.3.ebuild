# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="NEWS.md ../README.md"

RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_GEMSPEC="adsf.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Dead Simple Fileserver is a static file server that can launch in a directory"
HOMEPAGE="https://github.com/denisdefreyne/adsf/"
SRC_URI="https://github.com/denisdefreyne/adsf/archive/${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${P}/adsf"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="test"

ruby_add_rdepend "
	|| ( dev-ruby/rack:3.2 dev-ruby/rack:3.1 dev-ruby/rack:3.0 dev-ruby/rack:2.2 )
	>=dev-ruby/rackup-2.1:2
	|| ( dev-ruby/webrick www-servers/puma )
"

ruby_add_bdepend "test? ( dev-ruby/rack-test dev-ruby/webrick )"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/SimpleCov.command_name/ s:^:#:' \
		-e '/websocket/ s:^:#:' test/helper.rb || die
	sed -e '/test_receives_update/,/^  end/ s:^:#:' \
		-e '/test_non_local_interfaces/askip "networking"' \
		-e '/test_default_config__serve_index_html_in_subdir_missing_slash/askip "encoding"' \
		-e /'test_auto_extenion__defers_to_subdir_with_index/askip "encoding"' \
		-i test/test_server.rb || die
	sed -i -e '/rubocop/I s:^:#:' Rakefile || die
	rm -f test/test_version.rb || die

	sed -i -e "s:require_relative ':require './:" ${RUBY_FAKEGEM_GEMSPEC} || die
}

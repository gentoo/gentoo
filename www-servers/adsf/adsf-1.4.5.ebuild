# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="NEWS.md ../README.md"

RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_GEMSPEC="adsf.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Dead Simple Fileserver is a static file server that can launch in a directory"
HOMEPAGE="https://github.com/ddfreyne/adsf/"
SRC_URI="https://github.com/ddfreyne/adsf/archive/${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${P}/adsf"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-1.0.0:*"

ruby_add_bdepend "test? ( dev-ruby/rack-test )"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/SimpleCov.command_name/ s:^:#:' \
		-e '/websocket/ s:^:#:' test/helper.rb || die
	sed -e '/test_receives_update/,/^  end/ s:^:#:' \
		-e '/test_non_local_interfaces/askip "networking"' \
		-e '/test_default_config__serve_index_html_in_subdir_missing_slash/askip "encoding"' \
		-i test/test_server.rb || die
	sed -i -e '/rubocop/I s:^:#:' Rakefile || die
	rm -f test/test_version.rb || die

	sed -i -e "s:require_relative ':require './:" ${RUBY_FAKEGEM_GEMSPEC} || die
}

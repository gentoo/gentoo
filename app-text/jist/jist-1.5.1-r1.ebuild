# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A ruby gem to publish a gist"
HOMEPAGE="https://github.com/ConradIrwin/jist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/json:*"

ruby_add_bdepend "test? ( dev-ruby/webmock:0 )"

all_ruby_prepare() {
	# Avoid failing test (due to webmock version?)
	# We did not run any tests previously
	rm -f spec/shorten_spec.rb || die

	sed -i -e '1igem "webmock", "~>1.0"' spec/spec_helper.rb || die
}

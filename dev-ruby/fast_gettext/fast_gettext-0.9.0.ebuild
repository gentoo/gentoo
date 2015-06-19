# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/fast_gettext/fast_gettext-0.9.0.ebuild,v 1.2 2015/03/11 16:54:33 ago Exp $

EAPI=5

# jruby support requires sqlite3 support for jruby.
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG Readme.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="GetText but 3.5 x faster, 560 x less memory, simple, clean namespace (7 vs 34) and threadsave!"
HOMEPAGE="https://github.com/grosser/fast_gettext"
SRC_URI="https://github.com/grosser/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/activerecord dev-ruby/protected_attributes dev-ruby/bundler )"

all_ruby_prepare() {
	rm Gemfile.lock || die

	# Remove jeweler and bump from Gemfile since they are not needed for tests.
	sed -i -e '/jeweler/d' -e '/bump/d' -e '/appraisal/d' Gemfile || die

	# Avoid unneeded dependency on git and development dependencies.
	sed -e '/git ls-files/ s:^:#:' \
		-e '/\(wwtd\|bump\)/ s:^:#:' \
		-i fast_gettext.gemspec || die

	# Don't run a test that requires safe mode which we can't provide
	# due to insecure directory settings for the portage dir. This spec
	# also calls out to ruby which won't work with different ruby
	# implementations.
	sed -i -e '/can work in SAFE mode/,/^  end/ s:^:#:' spec/fast_gettext/translation_repository/mo_spec.rb || die

	# Avoid not failing pending specs related to ree18.
	sed -i -e '/with i18n loaded/,/^  end/ s:^:#:' spec/fast_gettext/vendor/string_spec.rb || die

	# Avoid RSpec 3 specific syntax
	sed -e '/failure_message/ s:^:#:' -i spec/support/be_accessible_matcher.rb || die

}

each_ruby_prepare() {
	# Make sure the right ruby interpreter is used
	sed -i -e "s:bundle exec ruby:bundle exec ${RUBY}:" spec/fast_gettext/vendor/*spec.rb || die
}

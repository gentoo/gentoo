# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG Readme.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="fast_gettext.gemspec"

inherit ruby-fakegem

DESCRIPTION="GetText but 3.5x faster, 560x less memory, clean namespace and threadsafe!"
HOMEPAGE="https://github.com/grosser/fast_gettext"
SRC_URI="https://github.com/grosser/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT BSD-2"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 x86"
IUSE="test"

ruby_add_depend "dev-ruby/prime"

ruby_add_bdepend "test? ( dev-ruby/bundler )"

all_ruby_prepare() {
	rm Gemfile.lock || die

	sed -i -e '/single/I s:^:#:' spec/spec_helper.rb || die
	sed -i -e '/SingleCov/ s:^:#:' spec/{*,*/*}/*spec.rb || die

	# Avoid unneeded dependency on git and development dependencies.
	sed -e '/git ls-files/ s:^:#:' \
		-e '/\(wwtd\|bump\|sqlite3\|activerecord\|i18n\|single_cov\|forking_test_runner\|rubocop\)/ s:^:#:' \
		-e 's:require_relative ":require "./:' \
		-i fast_gettext.gemspec || die

	# Avoid a test dependency on activerecord since this is now in the
	# dependency tree for app-admin/puppet and many arches don't have
	# rails keyworded.
	sed -i -e '/active_record/ s:^:#:' spec/spec_helper.rb || die
	rm -f spec/fast_gettext/translation_repository/db_spec.rb || die
	rm -f spec/fast_gettext/storage_spec.rb || die
	sed -i -e '/with i18n loaded/,/^  end/ s:^:#:' spec/fast_gettext/vendor/string_spec.rb || die
}

each_ruby_prepare() {
	# Make sure the right ruby interpreter is used
	sed -i -e "s:bundle exec ruby:bundle exec ${RUBY}:" spec/fast_gettext/vendor/*spec.rb || die
}

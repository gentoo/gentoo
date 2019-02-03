# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README"

# there is a stupid setup.rb in the bin/ directory so do not use the
# default.
RUBY_FAKEGEM_BINWRAP="s3sh"

inherit ruby-fakegem

DESCRIPTION="Client library for Amazon's Simple Storage Service's REST API"
HOMEPAGE="http://amazon.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/xml-simple
				dev-ruby/builder
				dev-ruby/mime-types:*
				virtual/ruby-ssl"
ruby_add_bdepend "test? ( dev-ruby/flexmock )"

RUBY_PATCHES=(
	${P}+ruby19.patch
)

all_ruby_prepare() {
	# Avoid tests requiring network access, bug 339324
	sed -i -e '/test_request_only_escapes_the_path_the_first_time_it_runs_and_not_subsequent_times/,/^  end/ s:^:#:' \
		-e '/test_if_request_has_no_body_then_the_content_length_is_set_to_zero/,/^  end/ s:^:#:' \
		test/connection_test.rb || die
}

each_ruby_test() {
	${RUBY} -I. -e "Dir['test/*_test.rb'].each {|f| require f }" || die
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
inherit ruby-fakegem

DESCRIPTION="An easy-to-use client library for making requests from Ruby"
HOMEPAGE="https://github.com/tarcieri/http"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~sparc"
IUSE=""

ruby_add_rdepend "=dev-ruby/addressable-2*
	>=dev-ruby/addressable-2.8
	=dev-ruby/http-cookie-1*
	>=dev-ruby/http-form_data-2.2:2
	>=dev-ruby/llhttp-ffi-0.4.0:0/0.4"

ruby_add_bdepend "
	test? (
		=dev-ruby/certificate_authority-1*
		dev-ruby/rspec-its
	)"

all_ruby_prepare() {
	# Avoid specs that require network access
	sed -i -e '/.persistent/,/^  end/ s:^:#:' \
		spec/lib/http_spec.rb || die
	sed -i -e '/with non-ASCII URLs/,/^    end/ s:^:#:' \
		spec/lib/http/client_spec.rb || die

	# Avoid spec that may fail with a running web server
	sed -i -e '/unifies socket errors into HTTP::ConnectionError/,/^  end/ s:^:#:' spec/lib/http_spec.rb || die

	# Fix spec for production release
	sed -i -e '/User-Agent:/ s/.dev//' spec/lib/http/features/logging_spec.rb || die

	# Avoid specs also failing upstream due to some certificate issue
	sed -i -e '/context "ssl"/,/^      end/ s:^:#:' spec/lib/http_spec.rb || die
	sed -i -e '/describe "working with SSL"/,/^  end/ s:^:#:' spec/lib/http/client_spec.rb || die

	# Disable coverage
	sed -i -e 's/require_relative ".\/support\/simplecov"//g' "spec/spec_helper.rb" || die

	# Submitted upstream as https://github.com/httprb/http/pull/719
	sed -i -e '4i require "cgi"' "spec/lib/http/client_spec.rb" || die
}

each_ruby_test() {
	# disables dev-ruby/fuubar dep
	CI=1 each_fakegem_test
}

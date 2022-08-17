# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="An easy-to-use client library for making requests from Ruby"
HOMEPAGE="https://github.com/tarcieri/http"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/addressable-2.3:0
	>=dev-ruby/http-cookie-1.0:0
	>=dev-ruby/http-form_data-2.2:2
	=dev-ruby/http-parser-1.2*"

ruby_add_bdepend "
	test? ( dev-ruby/certificate_authority dev-ruby/rspec-its )"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/end/ s:^:#:' \
		-e '1irequire "cgi"' spec/spec_helper.rb || die

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

	# Fix spec failing due to kwargs confusion on ruby30
	sed -i -e '196 s/:foo => "bar"/{:foo => "bar"}/' spec/lib/http/client_spec.rb || die
}

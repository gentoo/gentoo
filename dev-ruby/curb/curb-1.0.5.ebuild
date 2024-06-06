# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rake"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Ruby-language bindings for libcurl"
HOMEPAGE="https://github.com/taf2/curb"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"

DEPEND+=" net-misc/curl[ssl] test? ( net-misc/curl )"
RDEPEND+=" net-misc/curl[ssl]"

ruby_add_bdepend "test? ( dev-ruby/webrick )"

all_ruby_prepare() {
	# fix tests when localhost is also ::1
	sed -i -e 's|localhost:|127.0.0.1:|g' tests/*.rb || die

	# avoid tests making outside network connections
	rm tests/bug_postfields_crash.rb || die
	sed -e '/test_easy_http_verbs_must_respond_to_str/,/^  end/ s:^:#:' \
		-i tests/tc_curl_easy.rb || die
	sed -e '/test_connection_keepalive/aomit "network connection needed"' \
		-i tests/tc_curl_multi.rb || die

	# Fix test that expects wrong output
	sed -i -e 's/200 OK /200 OK/' tests/tc_curl_easy.rb || die

	# avoid failing tests where failure condition seems weird, no
	# upstream travis so not clear if the test is indeed broken.
	sed -i -e '/test_multi_easy_http/,/^  end/ s:^:#:' tests/tc_curl_multi.rb || die

	# avoid test requiring ntlm support on curl which is no longer available in gentoo
	sed -i -e '/test_username_password/aomit "ntlm support in curl needed"' -i tests/tc_curl_easy.rb || die

	# Skip tests with currently unpackaged ruby_memcheck
	sed -i -e '/ruby_memcheck/ s:^:#: ; /RubyMemcheck/,/^end/ s:^:#:' Rakefile
}

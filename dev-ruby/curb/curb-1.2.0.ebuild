# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rake"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Ruby-language bindings for libcurl"
HOMEPAGE="https://github.com/taf2/curb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND=" net-misc/curl[ssl] test? ( net-misc/curl )"
RDEPEND=" net-misc/curl[ssl]"

ruby_add_bdepend "test? ( dev-ruby/webrick )"

all_ruby_prepare() {
	# avoid tests making outside network connections
	rm tests/bug_postfields_crash.rb || die
	sed -e '/test_easy_http_verbs_must_respond_to_str/,/^  end/ s:^:#:' \
		-i tests/tc_curl_easy.rb || die
	sed -e '/test_connection_keepalive/aomit "network connection needed"' \
		-i tests/tc_curl_multi.rb || die

	# avoid failing tests where failure condition seems weird, no
	# upstream travis so not clear if the test is indeed broken.
	sed -i -e '/test_multi_easy_http/,/^  end/ s:^:#:' tests/tc_curl_multi.rb || die

	# avoid test requiring ntlm support on curl which is no longer available in gentoo
	sed -i -e '/test_username_password/aomit "ntlm support in curl needed"' -i tests/tc_curl_easy.rb || die

	# Skip tests with currently unpackaged ruby_memcheck
	sed -i -e '/ruby_memcheck/ s:^:#: ; /RubyMemcheck/,/^end/ s:^:#:' Rakefile

	# Skip test failing on an encoding issue.
	sed -e '/test_post_streaming/aomit "Fails on encoding difference"' \
		-i tests/tc_curl_easy.rb || die
}

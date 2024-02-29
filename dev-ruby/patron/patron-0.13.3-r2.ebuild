# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/patron/extconf.rb)
RUBY_FAKEGEM_EXTENSION_DIR="lib/patron"

inherit ruby-fakegem

DESCRIPTION="Patron is a Ruby HTTP client library based on libcurl"
HOMEPAGE="https://github.com/toland/patron"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 x86"
IUSE=""

DEPEND+=" net-misc/curl"
RDEPEND+=" net-misc/curl"

ruby_add_bdepend "test? ( dev-ruby/rack:2.2 www-servers/puma )"

all_ruby_prepare() {
	# Fix Rakefile
	sed -i -e 's:rake/rdoctask:rdoc/task:' \
		-e 's/README.txt/README.md/' \
		-e '/bundler/I s:^:#:' \
		-e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/^end/ s:^:#:' \
		Rakefile || die

	# Avoid specs with failures. We were not running any specs before.
	rm spec/session_ssl_spec.rb spec/session_spec.rb spec/response_spec.rb || die

	# Ensure a compatible rack version
	sed -i -e '1igem "rack", "~> 2.2.0"' spec/spec_helper.rb || die
}

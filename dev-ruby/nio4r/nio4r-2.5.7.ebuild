# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/nio4r/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="A high performance selector API for monitoring IO objects"
HOMEPAGE="https://github.com/socketry/nio4r"

LICENSE="MIT || ( BSD GPL-2 )"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# Note that nio4r bundles a patched copy of libev, and without these
# patches the tests fail: https://github.com/celluloid/nio4r/issues/15

ruby_add_bdepend "test? ( dev-ruby/rspec-retry )"

all_ruby_prepare() {
	sed -i -e '/[Cc]overalls/d' -e '/[Bb]undler/d' -e '1irequire "openssl"' spec/spec_helper.rb || die
	sed -e '/extension/ s:^:#:' -i Rakefile || die
}

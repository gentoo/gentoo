# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

# no documentation is generable, it needs hanna, which is broken
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="MT_NO_PLUGINS=true test"

RUBY_FAKEGEM_EXTRADOC="README.md AUTHORS.md CHANGELOG.md"

inherit ruby-fakegem

DESCRIPTION="A DSL for quickly creating web applications in Ruby with minimal effort"
HOMEPAGE="http://www.sinatrarb.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "=dev-ruby/rack-1*:* >=dev-ruby/rack-1.5:*
	>=dev-ruby/rack-protection-1.4:1
	>=dev-ruby/tilt-1.3.4:* <dev-ruby/tilt-3:*"
ruby_add_bdepend "test? ( >=dev-ruby/rack-test-0.5.6 dev-ruby/erubis dev-ruby/builder )"

# haml tests are optional and not yet marked for ruby20.
#USE_RUBY="ruby20" ruby_add_bdepend "test? ( >=dev-ruby/haml-3.0 )"

all_ruby_prepare() {
	# Remove implicit build dependency on git.
	sed -i -e '/\(s.files\|s.test_files\|s.extra_rdoc_files\)/d' sinatra.gemspec || die

	# Use correct rack version in tests
	sed -i -e '1igem "rack", "~> 1.5"' test/helper.rb test/integration/app.rb || die
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/httpclient/httpclient-2.5.3.3.ebuild,v 1.2 2015/02/01 15:30:17 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="-Ilib test"
RUBY_FAKEGEM_TASK_DOC="doc"

RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="'httpclient' gives something like the functionality of libwww-perl (LWP) in Ruby"
HOMEPAGE="https://github.com/nahi/httpclient"
SRC_URI="https://github.com/nahi/httpclient/archive/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="Ruby"
SLOT="0"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="${RDEPEND}
	!dev-ruby/http-access2"

ruby_add_rdepend "virtual/ruby-ssl"

ruby_add_bdepend "doc? ( dev-ruby/rdoc )"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[bB]undler/s:^:#:' Rakefile || die

	# Fix documentation task
	sed -i -e 's/README.txt/README.md/' Rakefile || die

	# Remove mandatory CI reports since we don't need this for testing.
	sed -i -e '/reporter/s:^:#:' Rakefile || die

	# Remove mandatory simplecov dependency
	sed -i -e '/[Ss]imple[Cc]ov/ s:^:#:' test/helper.rb || die

	# Comment out test requiring network access that makes assumptions
	# about the environment, bug 395155
	sed -i -e '/test_async_error/,/^  end/ s:^:#:' test/test_httpclient.rb || die

	# Skip tests using rack-ntlm which is not packaged. Weirdly these
	# only fail on jruby.
	rm test/test_auth.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb test/test_*.rb || die
}

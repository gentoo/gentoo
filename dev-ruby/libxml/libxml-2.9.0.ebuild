# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_NAME="libxml-ruby"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc HISTORY"

inherit ruby-fakegem

DESCRIPTION="Ruby libxml with a user friendly API, akin to REXML"
HOMEPAGE="https://github.com/xml4r/libxml-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="${RDEPEND} dev-libs/libxml2"
DEPEND="${DEPEND} dev-libs/libxml2"

ruby_add_bdepend "doc? ( dev-ruby/rdoc )"

all_ruby_prepare() {
	# Remove grancher tasks only needed for publishing the website
	sed -i -e '/grancher/d' -e '/Grancher/,$d' Rakefile || die

	# We don't have the hanna template available.
	sed -i -e 's/hanna/rake/' Rakefile || die

	# Remove rake-compiler bits since we don't use it
	sed -i -e '/extensiontask/d' -e '/ExtensionTask/,/end/d' -e '/GemPackageTask/,/end/d' Rakefile || die

	# Avoid test that fails intermittently
	sed -i -e '/test_get_handler/,/^  end/ s:^:#:' test/tc_error.rb || die
}

each_ruby_configure() {
	${RUBY} -C ext/libxml extconf.rb || die
}

each_ruby_compile() {
	emake -C ext/libxml V=1
	cp ext/libxml/libxml_ruby.so lib/ || die
}

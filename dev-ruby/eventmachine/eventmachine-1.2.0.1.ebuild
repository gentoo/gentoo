# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ruby20 crashes in test suite
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="docs/*.md README.md"

inherit ruby-fakegem

DESCRIPTION="EventMachine is a fast, simple event-processing library for Ruby programs"
HOMEPAGE="http://rubyeventmachine.com"

LICENSE="|| ( GPL-2 Ruby )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="${DEPEND}
	dev-libs/openssl:0"
RDEPEND="${RDEPEND}
	dev-libs/openssl:0"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	# Remove package tasks to avoid dependency on rake-compiler.
	rm rakelib/package.rake || die

	# fix test issue - upstream b96b736b39261f7d74f013633cc7cd619afa20c4
	sed -i -e 's/DEBUG/BROADCAST/g' tests/test_set_sock_opt.rb || die
	sed -i -e "/omit_/d" tests/test_*.rb || die
	# Remove the resolver tests since they require network access and
	# the localhost test fails with an IPv6 localhost.
	rm tests/test_resolver.rb || die
	# Needs a tty
	rm tests/test_kb.rb || die
	# Avoid tests that require network access
	sed -i -e '/test_bind_connect/,/^  end/ s:^:#:' \
		tests/test_basic.rb || die
	sed -i -e '/test_\(cookie\|http_client\|version_1_0\)/,/^  end/ s:^:#:' \
		tests/test_httpclient.rb || die
	sed -i -e '/test_\(get\|https_get\)/,/^  end/ s:^:#:' \
		tests/test_httpclient2.rb || die
	sed -i -e '/test_connect_timeout/,/^  end/ s:^:#:' \
		tests/test_unbind_reason.rb || die
	sed -i -e '/test_for_real/,/^    end/ s:^:#:' \
		tests/test_pending_connect_timeout.rb || die
	rm -f tests/test_{get_sock_opt,set_sock_opt,idle_connection}.rb || die
}

each_ruby_configure() {
	for extdir in ext ext/fastfilereader; do
		pushd $extdir
		${RUBY} extconf.rb || die "extconf.rb failed for ${extdir}"
		popd
	done
}

each_ruby_compile() {
	for extdir in ext ext/fastfilereader; do
		pushd $extdir
		# both extensions use C++, so use the CXXFLAGS not the CFLAGS
		emake V=1 CFLAGS="${CXXFLAGS} -fPIC" archflag="${LDFLAGS}" || die "emake failed for ${extdir}"
		popd
		cp $extdir/*.so lib/ || die "Unable to copy extensions for ${extdir}"
	done
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb tests/test_*.rb || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}/
	doins -r examples || die "Failed to install examples"
}

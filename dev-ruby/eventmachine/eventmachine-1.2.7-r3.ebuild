# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="docs/*.md CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="eventmachine.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb ext/fastfilereader/extconf.rb)
RUBY_FAKEGEM_EXTRAINSTALL=(examples)

inherit ruby-fakegem

DESCRIPTION="EventMachine is a fast, simple event-processing library for Ruby programs"
HOMEPAGE="https://github.com/eventmachine/eventmachine"
SRC_URI="https://github.com/eventmachine/eventmachine/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# Collection of upstream patches to fix compatibility with newer OpenSSL
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-openssl-patches.tar.bz2"

LICENSE="|| ( GPL-2 Ruby-BSD )"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="${DEPEND}
	dev-libs/openssl:0="
RDEPEND="${RDEPEND}
	dev-libs/openssl:0="

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

PATCHES=(
	# Collection of upstream patches (rebased by Fedora, thanks!) to
	# fix (mostly test) compatibility with >= OpenSSL 1.1.1.
	"${WORKDIR}"/all/patches/
)

all_ruby_prepare() {
	# Remove package tasks to avoid dependency on rake-compiler.
	rm rakelib/package.rake || die

	sed -i -e '/git ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || die
	# Remove the resolver tests since they require network access and
	# the localhost test fails with an IPv6 localhost.
	rm tests/test_resolver.rb || die

	# Needs a tty
	rm tests/test_kb.rb || die

	# Avoid tests that require network access
	sed -e '/test_bind_connect/,/^  end/ s:^:#:' \
		-e '/test_invalid_address_bind_connect_src/,/^  end/ s:^:#:' \
		-e '/test_invalid_address_bind_connect_dst/,/^  end/ s:^:#:' \
		-i tests/test_basic.rb || die
	sed -e '/test_ipv6_udp_local_server/,/^    end/ s:^:#:' \
		-e '/test_ipv6_tcp_local_server/,/^    end/ s:^:#:' \
		-i tests/test_ipv6.rb || die
	sed -e '/test_for_real/,/^    end/ s:^:#:' -i tests/test_pending_connect_timeout.rb || die
	sed -e '/test_connect_timeout/,/^  end/ s:^:#:' -i tests/test_unbind_reason.rb || die
	sed -e '/test_cookie/,/^  end/ s:^:#:' \
		-e '/test_http_client/,/^  end/ s:^:#:' \
		-e '/test_version_1_0/,/^  end/ s:^:#:' \
		-i tests/test_httpclient.rb || die
	sed -e '/test_get/,/^  end/ s:^:#:' \
		-e '/test_https_get/,/^  end/ s:^:#:' \
		-i tests/test_httpclient2.rb || die

	# Avoid test that deliberately triggers a C++ exception which causes
	# a SEGFAULT. This does not appear to happen upstream (on travis).
	rm tests/test_exc.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb-2 tests/test_*.rb || die
}

all_ruby_install() {
	all_fakegem_install
}

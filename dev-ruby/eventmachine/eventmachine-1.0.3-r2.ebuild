# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
# ruby22 - code does not compile
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC="yard"
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
	dev-libs/openssl"
RDEPEND="${RDEPEND}
	dev-libs/openssl"

ruby_add_bdepend "doc? ( dev-ruby/yard )"

all_ruby_prepare() {
	# Remove package tasks to avoid dependency on rake-compiler.
	rm rakelib/package.rake || die

	# fix test issue - upstream b96b736b39261f7d74f013633cc7cd619afa20c4
	sed -i -e 's/DEBUG/BROADCAST/g' tests/test_set_sock_opt.rb || die

	# Remove the resolver tests since they require network access and
	# the localhost test fails with an IPv6 localhost.
	rm tests/test_resolver.rb || die
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

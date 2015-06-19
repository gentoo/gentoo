# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubyzip/rubyzip-1.1.7.ebuild,v 1.4 2015/06/08 05:01:45 jer Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md TODO"

inherit ruby-fakegem

DESCRIPTION="A ruby library for reading and writing zip files"
HOMEPAGE="https://github.com/rubyzip/rubyzip"
# Tests are not included in the gem.
SRC_URI="https://github.com/rubyzip/rubyzip/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="Ruby"
SLOT="1"
KEYWORDS="~amd64 hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${DEPEND} test? ( app-arch/zip )"

ruby_add_bdepend "test? ( dev-ruby/minitest:5 )"

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc samples/*
}

all_ruby_prepare() {
	# Avoid dependencies on simplecov and coveralls
	sed -i -e '/simplecov/ s:^:#:' test/test_helper.rb || die

	# Avoid dependency on bundler
	sed -i -e '/bundler/ s:^:#:' Rakefile || die

	# Fix hardcoded path to /tmp
	sed -i -e 's:/tmp/:'${T}'/:g' test/entry_test.rb || die
}

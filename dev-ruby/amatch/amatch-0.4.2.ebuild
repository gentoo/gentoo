# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Approximate Matching Extension for Ruby"
HOMEPAGE="https://github.com/flori/amatch"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend "
	dev-ruby/mize
	=dev-ruby/tins-1*
"

# These packages also provide agrep, bug 626480
RDEPEND="!dev-libs/tre"

all_ruby_prepare() {
	# mize is listed as a dependency but not actually used
	sed -i -e '/mize/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb-2 tests/* || die
}

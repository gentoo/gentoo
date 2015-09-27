# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md doc/text/news.md"

inherit ruby-fakegem

# Assume for now that ruby22 is not eselected yet and only depend on
# yard for the other ruby implementations. Without this assumption
# bootstrapping ruby22 won't be possible due to the yard dependency
# tree.
#USE_RUBY="${USE_RUBY/ruby22/}" ruby_add_bdepend "doc? ( dev-ruby/yard )"
ruby_add_bdepend "doc? ( dev-ruby/yard )"

DESCRIPTION="An xUnit family unit testing framework for Ruby"
HOMEPAGE="https://rubygems.org/gems/test-unit"

LICENSE="|| ( Ruby GPL-2 ) PSF-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

# power_assert does not work with ruby19 but is not needed for backward
# compatibility:
# https://github.com/k-tsj/power_assert/issues/8#issuecomment-71363455
USE_RUBY="${USE_RUBY/ruby19/}" ruby_add_rdepend "dev-ruby/power_assert"

each_ruby_prepare() {
	case ${RUBY} in
		*ruby19)
			# Remove metadata to avoid registering the unsupported
			# power_assert dependency.
			rm -f ../metadata || die
			;;
	esac
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc; then
		yard doc --title ${PN} || die
	fi
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die "testsuite failed"
}

all_ruby_install() {
	all_fakegem_install

	newbin "${FILESDIR}"/testrb-3 testrb-2
}

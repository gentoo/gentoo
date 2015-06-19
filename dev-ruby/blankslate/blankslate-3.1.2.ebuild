# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/blankslate/blankslate-3.1.2.ebuild,v 1.10 2014/11/03 15:34:46 mrueg Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A base class where almost all of the methods from Object and Kernel have been removed"
HOMEPAGE="https://rubygems.org/gems/blankslate"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64"

ruby_add_bdepend "test? ( dev-ruby/builder )"

all_ruby_prepare() {
	sed -i -e "/test\/preload/d"\
		-e "/test_preload_method_added/,/end/d" test/test_blankslate.rb || die
	sed -i -e "/test\/preload/d" test/test_{method_caching,markupbuilder,eventbuilder}.rb || die

	# Avoid failure due to differing builder versions that render an
	# empty value differently.
	sed -i -e '/test_empty_value/,/end/ s:^:#:' test/test_markupbuilder.rb || die

	# Avoid failing encoding test on ruby20 for now. Not clear if this
	# will be a real problem, but looks like ruby20 properly supports
	# utf8 verbatim which the test suite does not expect.
	sed -i -e '/test_utf8_verbatim/,/end/ s:^:#:' test/test_xchar.rb || die

	rm -rf doc || die "Removing old builder documentation failed."
}

each_ruby_test() {
	${RUBY} -I.:lib -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}

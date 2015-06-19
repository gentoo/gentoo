# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/sdoc/sdoc-0.4.1.ebuild,v 1.1 2015/05/14 09:07:08 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-fakegem

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_TASK_TEST="spec"

DESCRIPTION="rdoc generator html with javascript search index"
HOMEPAGE="https://rubygems.org/gems/sdoc"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/json-1.7:0
	=dev-ruby/rdoc-4*"

ruby_add_bdepend "test? ( dev-ruby/minitest:0 )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/ s:^:#:' sdoc.gemspec || die
}

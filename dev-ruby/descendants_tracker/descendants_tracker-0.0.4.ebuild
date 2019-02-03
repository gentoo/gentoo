# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Module that adds descendant tracking to a class"
HOMEPAGE="https://github.com/dkubb/descendants_tracker"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/thread_safe"

all_ruby_prepare() {
	# Remove dependency on devtools
	sed -i -e '/devtools\/spec_helper/d' spec/spec_helper.rb || die
	sed -i -e '/it_should_behave_like/d' \
		spec/unit/descendants_tracker/add_descendant_spec.rb || die
	sed -i -e '/it_should_behave_like/d' \
		spec/unit/descendants_tracker/descendants_spec.rb || die
}

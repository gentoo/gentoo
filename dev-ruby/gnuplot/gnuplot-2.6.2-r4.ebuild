# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="AUTHORS.txt ChangeLog README.textile"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Gnuplot drawing library - Ruby Bindings"
HOMEPAGE="https://rubygems.org/gems/gnuplot"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND="sci-visualization/gnuplot"

ruby_add_bdepend "test? ( dev-ruby/matrix )"

all_ruby_prepare() {
	# Existing metadata causes a crash in jruby, so use our own.
	rm -f ../metadata || die "Unable to remove metadata."

	sed -i -e 's/Config/RbConfig/' test/test_gnuplot.rb || die
}

each_ruby_test() {
	${RUBY} -Ctest test_gnuplot.rb || die
}

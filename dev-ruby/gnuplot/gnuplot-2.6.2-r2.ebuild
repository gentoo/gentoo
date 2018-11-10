# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="AUTHORS.txt ChangeLog README.textile"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Gnuplot drawing library - Ruby Bindings"
HOMEPAGE="http://rgplot.rubyforge.org/"

LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
SLOT="0"

RDEPEND+=" sci-visualization/gnuplot"

all_ruby_prepare() {
	# Existing metadata causes a crash in jruby, so use our own.
	rm -f ../metadata || die "Unable to remove metadata."

	sed -i -e 's/Config/RbConfig/' test/test_gnuplot.rb || die
}

each_ruby_test() {
	${RUBY} -Ctest test_gnuplot.rb || die
}

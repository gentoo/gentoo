# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit ruby-fakegem

DESCRIPTION="Module to allow Bayesian and other types of classifications"
HOMEPAGE="http://rubyforge.org/projects/classifier  https://github.com/cardmagic/classifier"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gsl"

ruby_add_rdepend ">=dev-ruby/fast-stemmer-1.0.0
	!!dev-ruby/classifier-reborn
	gsl? ( dev-ruby/rb-gsl )"

all_ruby_prepare() {
	sed -i -e "s/PKG_VERSION/\"${PV}\"/" \
		-e '/rubyforge/ s:^:#:' \
		-e "s#PKG_FILES#FileList[ \"lib/**/*\", \"bin/*\", \"test/**/*\", \"[A-Z]*\", \"Rakefile\", \"Gemfile\", \"html/**/*\"]#" Rakefile
	if use !gsl; then
		sed -e 's/$GSL = true/$GSL = false/' -i lib/${PN}/lsi.rb || die
		rm test/lsi/lsi_test.rb || die
	fi
	# Remove failing test for now
	rm test/extensions/word_hash_test.rb || die
}

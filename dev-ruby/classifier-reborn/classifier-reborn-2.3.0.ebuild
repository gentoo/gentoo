# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.markdown"
RUBY_FAKEGEM_GEMSPEC="classifier-reborn.gemspec"

inherit ruby-fakegem

DESCRIPTION="Module to allow Bayesian and other types of classifications"
HOMEPAGE="https://github.com/jekyll/classifier-reborn"
SRC_URI="https://github.com/jekyll/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="gsl test"

ruby_add_rdepend "
	>=dev-ruby/fast-stemmer-1.0.0
	>=dev-ruby/matrix-0.4:0
	gsl? ( dev-ruby/rb-gsl )"
ruby_add_bdepend "test? ( dev-ruby/redis )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e "/[Bb]undler/d" Rakefile || die
	if use !gsl; then
		sed -e 's/$GSL = true/$GSL = false/'\
			-e 's/vector_serialize/vector/'\
			-i lib/${PN}/lsi.rb || die
	fi

	sed -i -e '/reporters/I s:^:#:' -e '/pry/ s:^:#:' test/test_helper.rb || die
}

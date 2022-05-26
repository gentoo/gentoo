# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

inherit ruby-fakegem

DESCRIPTION="A simple set of utility functions for Hash"
HOMEPAGE="http://trac.misuse.org/science/wiki/DeepMerge"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ~ppc64 ~sparc x86"
IUSE=""

each_ruby_test() {
	${RUBY} -I lib:test:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}

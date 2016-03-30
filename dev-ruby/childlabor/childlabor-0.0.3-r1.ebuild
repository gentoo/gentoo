# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A scripting framework that replaces rake and sake"
HOMEPAGE="https://github.com/carllerche/childlabor"
COMMIT_ID="6518b939dddbad20c7f05aa075d76e3ca6e70447"
SRC_URI="https://github.com/carllerche/childlabor/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test"

RUBY_S="${PN}-${COMMIT_ID}"

ruby_add_bdepend "test? ( dev-ruby/rspec:2 )"

all_ruby_prepare() {
	# Avoid failing spec. The signals work, but the stdout handling
	# doesn't seem to play nice with portage.
	sed -i -e '/can send signals/,/^  end/ s:^:#:' spec/task_spec.rb || die
}

each_ruby_test() {
	ruby-ng_rspec -I. spec/task_spec.rb || die
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="childlabor.gemspec"

inherit ruby-fakegem

DESCRIPTION="Gem that helps manage child processes"
HOMEPAGE="https://github.com/carllerche/childlabor"
COMMIT_ID="6518b939dddbad20c7f05aa075d76e3ca6e70447"
SRC_URI="https://github.com/carllerche/childlabor/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"

RUBY_S="${PN}-${COMMIT_ID}"

ruby_add_bdepend "test? ( dev-ruby/rspec:3 )"

all_ruby_prepare() {
	# Avoid failing spec. The signals work, but the stdout handling
	# doesn't seem to play nice with portage.
	sed -i -e '/can send signals/,/^  end/ s:^:#:' spec/task_spec.rb || die

	# Rspec 3 compatibility
	sed -i -e 's/Spec::Runner/RSpec/' spec/spec_helper.rb || die
	sed -i -e 's/be_false/be_falsey/ ; s/be_true/be true/' spec/task_spec.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec -I. spec/task_spec.rb || die
}

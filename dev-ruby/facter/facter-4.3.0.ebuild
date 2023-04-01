# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"
RUBY_FAKEGEM_GEMSPEC="facter.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-ng ruby-fakegem

DESCRIPTION="A cross-platform ruby library for retrieving facts from operating systems"
HOMEPAGE="http://www.puppetlabs.com/puppet/related-projects/facter/"

LICENSE="Apache-2.0"
SLOT="0"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/puppetlabs/facter.git"
	EGIT_BRANCH="master"
else
	[[ "${PV}" = *_rc* ]] || \
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"
	SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

ruby_add_rdepend "dev-ruby/hocon <dev-ruby/thor-2.0 dev-ruby/ffi"
ruby_add_bdepend "test? ( dev-ruby/timecop dev-ruby/webmock )"

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	fi
	ruby-ng_src_unpack
}

all_ruby_prepare() {
	sed -e 's/__dir__/"."/' \
		-e 's/__FILE__/"'${RUBY_FAKEGEM_GEMSPEC}'"/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Linting and coverage aren't useful for us in testing
	# Also loosen dependencies
	sed -i \
		-e '/rubocop/d' \
		-e '/simplecov/d' \
		-e '/rake/s:~> 12.3:>= 12.3:' \
		-e '/yard/s:~> 0.9:>= 0.9:' \
		-e '/sys-filesystem/d' \
		-e '/octokit/d' \
		${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i \
		-e '/octokit/d' \
		-e '/packaging/d' \
		-e '/ronn/d' \
		Gemfile || die

	sed -i \
		-e '/simplecov/d' \
		-e '/SimpleCov.start/,/^end/ s:^:#:' \
		-e '/SimpleCov/d' \
		spec/spec_helper.rb || die
	rm tasks/{check,rubocop}.rake || die

	# Breaks tests; handle deps ourselves
	#sed -e "/require 'bundler/d" -i spec/spec_helper.rb || die
}

each_ruby_test() {
	each_fakegem_test --trace
}

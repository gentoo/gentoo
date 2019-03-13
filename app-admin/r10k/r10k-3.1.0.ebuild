# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Puppet environment and module deployment"
HOMEPAGE="https://github.com/puppetlabs/r10k"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+git"

ruby_add_rdepend "
	~dev-ruby/colored-1.2
	=dev-ruby/cri-2.15*
	>=dev-ruby/gettext-setup-0.24:0
	~dev-ruby/log4r-1.1.10
	>=dev-ruby/multi_json-1.10:0
	>=dev-ruby/puppet_forge-2.2.8
	=dev-ruby/puppet_forge-2.2*
"

ruby_add_bdepend "test? (
	dev-ruby/archive-tar-minitar
)"

RDEPEND="${RDEPEND} git? ( >=dev-vcs/git-1.6.6 )"

all_ruby_prepare() {
	sed -i -e 's/json_pure/json/' \
		-e '/cri/ s/2\.6\../2.7/' \
		-e '/systemu/ s/2.5.2/2.5/' \
		-e '/faraday/ s/0.9.0/0.9/' \
		-e '/semantic_puppet/ s/~>/>/' \
		-e '/s.files/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid specs for unpackaged rugget git provider
	rm -rf spec/unit/git_spec.rb spec/unit/git/rugged || die
}

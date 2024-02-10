# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_EXTRAINSTALL=locales

inherit ruby-fakegem

DESCRIPTION="Puppet environment and module deployment"
HOMEPAGE="https://github.com/puppetlabs/r10k"
SRC_URI="https://github.com/puppetlabs/r10k/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+git"

ruby_add_rdepend "
	~dev-ruby/colored2-3.1.2
	>=dev-ruby/cri-2.15.10:0
	dev-ruby/gettext-setup:1
	>=dev-ruby/jwt-2.2.3:2 <dev-ruby/jwt-2.8.0:2
	>=dev-ruby/ruby-gettext-3.0.2:0
	~dev-ruby/log4r-1.1.10
	>=dev-ruby/minitar-0.9:0
	>=dev-ruby/multi_json-1.10:0
	dev-ruby/puppet_forge:5
"

ruby_add_bdepend "test? (
	>=dev-ruby/minitar-0.9
)"

RDEPEND="${RDEPEND} git? ( >=dev-vcs/git-1.6.6 )"

all_ruby_prepare() {
	sed -e '/s.files/d' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid specs for unpackaged rugget git provider
	rm -rf spec/unit/git_spec.rb spec/unit/git/rugged || die

	# Avoid spec making assumptions on availability of relative symlinks
	rm -f spec/integration/util/purageable_spec.rb || die
}

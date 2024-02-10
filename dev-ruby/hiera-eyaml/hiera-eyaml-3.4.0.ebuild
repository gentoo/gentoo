# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md PLUGINS.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Encrypted YAML backend for hiera"
HOMEPAGE="https://github.com/voxpupuli/hiera-eyaml"
SRC_URI="https://github.com/voxpupuli/hiera-eyaml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/highline-1.6.19:*
	dev-ruby/optimist
"

ruby_add_bdepend "test? (
	dev-util/cucumber
	~dev-util/aruba-0.6.2
	dev-ruby/hiera-eyaml-plaintext
)"

BDEPEND+=" test? ( || ( app-admin/puppet-agent app-admin/puppet ) dev-tcltk/expect )"

all_ruby_prepare() {
	# Fix highline dependency to be compatible with more versions.
	sed -i -e '/highline/ s/~>/>=/' \
		-e '/gem.files/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e "s:/tmp:${T}:" \
		features/sandbox/puppet/environments/local/modules/test/manifests/run.pp \
		features/sandbox/puppet-hiera-merge/environments/local/modules/test/manifests/run.pp \
		features/sandbox/puppet-envvar/environments/local/modules/test/manifests/run.pp \
		features/puppet.feature
}

each_ruby_prepare() {
	# Run tests with the correct ruby interpreter
	sed -i -e 's:I run `eyaml:I run `'${RUBY}' '"${S}"'/bin/eyaml:' features/*.feature || die

}

each_ruby_test() {
	CUCUMBER_PUBLISH_QUIET=true ${RUBY} -S cucumber --format progress features || die
}

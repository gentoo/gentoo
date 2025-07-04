# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md PLUGINS.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Encrypted YAML backend for hiera"
HOMEPAGE="https://github.com/voxpupuli/hiera-eyaml"
SRC_URI="https://github.com/voxpupuli/hiera-eyaml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

ruby_add_rdepend "
	dev-ruby/highline:3
	>=dev-ruby/optimist-3.1:3
	!<dev-ruby/hiera-eyaml-3.4.0-r1
"

ruby_add_bdepend "test? (
	>=dev-util/cucumber-8
	dev-util/aruba:2
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

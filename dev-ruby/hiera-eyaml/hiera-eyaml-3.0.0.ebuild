# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md PLUGINS.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Encrypted YAML backend for hiera"
HOMEPAGE="https://github.com/TomPoulton/hiera-eyaml"
SRC_URI="https://github.com/TomPoulton/hiera-eyaml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/highline-1.6.19:*"
ruby_add_rdepend "dev-ruby/optimist"
ruby_add_rdepend "!!dev-ruby/hiera-eyaml:0" # both install the /usr/bin/eyaml binary

ruby_add_bdepend "test? ( dev-util/cucumber ~dev-util/aruba-0.6.2 <app-admin/puppet-6 dev-ruby/hiera-eyaml-plaintext )"

all_ruby_prepare() {
	# Fix highline dependency to be compatible with more versions.
	sed -i -e '/highline/ s/~>/>=/' \
		-e '/gem.files/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e 's:/tmp:'${T}':' \
		features/sandbox/puppet/environments/local/modules/test/manifests/run.pp \
		features/sandbox/puppet-hiera-merge/environments/local/modules/test/manifests/run.pp \
		features/puppet.feature
}

each_ruby_prepare() {
	# Run tests with the correct ruby interpreter
	sed -i -e 's:I run `eyaml:I run `'${RUBY}' '${S}'/bin/eyaml:' features/*.feature || die

}

each_ruby_test() {
	${RUBY} -S cucumber --format progress features || die
}

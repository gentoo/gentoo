# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md CHANGES.md PLUGINS.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Encrypted YAML backend for hiera"
HOMEPAGE="https://github.com/TomPoulton/hiera-eyaml"
SRC_URI="https://github.com/TomPoulton/hiera-eyaml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/highline-1.6.19"
ruby_add_rdepend "dev-ruby/trollop:2"

ruby_add_bdepend "test? ( dev-util/cucumber dev-util/aruba app-admin/puppet dev-ruby/hiera-eyaml-plaintext )"

all_ruby_prepare() {
	# Fix highline dependency to be compatible with more versions.
	sed -i -e '/highline/ s/~>/>=/' \
		-e '/gem.files/d' ${RUBY_FAKEGEM_GEMSPEC} || die

}

each_ruby_test() {
	${RUBY} -S cucumber --format progress features || die
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="multipart-post.gemspec"

inherit ruby-fakegem

DESCRIPTION="Adds a streamy multipart form post capability to Net::HTTP"
HOMEPAGE="https://github.com/socketry/multipart-post"
SRC_URI="https://github.com/socketry/multipart-post/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die

	sed -i -e 's:_relative ":"./:' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Remove warnings since these are only actionable for developers,
	# not for people consuming this package as part of other tools.
	sed -i -e '/Top level/ s/warn/# warn/' lib/*.rb || die
}

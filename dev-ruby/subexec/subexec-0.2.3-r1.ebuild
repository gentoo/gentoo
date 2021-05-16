# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem eutils

GITHUB_USER="nulayer"

DESCRIPTION="Subexec spawns an external command with a timeout"
HOMEPAGE="https://github.com/nulayer/subexec"
SRC_URI="https://github.com/${GITHUB_USER}/${PN}/archive/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/shoulda )"

all_ruby_prepare() {
	rm Gemfile* || die
	sed -i -e '/[Bb]undler/ s:^:#:' Rakefile || die
	sed -i -e '/begin/,/end/ s:^:#:' spec/spec_helper.rb || die
}

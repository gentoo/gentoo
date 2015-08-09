# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem eutils

GITHUB_USER="nulayer"

DESCRIPTION="Subexec spawns an external command with a timeout"
HOMEPAGE="http://github.com/nulayer/subexec"
SRC_URI="http://github.com/${GITHUB_USER}/${PN}/archive/v${PV}.tar.gz -> ${P}.tgz"

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

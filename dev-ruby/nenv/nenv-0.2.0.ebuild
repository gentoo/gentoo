# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"
inherit ruby-fakegem

DESCRIPTION="Convenient wrapper for Ruby's ENV"
HOMEPAGE="https://github.com/e2/nenv"
SRC_URI="https://github.com/e2/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

all_ruby_prepare() {
	sed -i -e "/[Cc]overalls/d" spec/spec_helper.rb || die
}

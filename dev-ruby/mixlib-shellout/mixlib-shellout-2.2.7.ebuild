# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRA_DOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Run external commands on Unix or Windows"
HOMEPAGE="https://github.com/opscode/mixlib-shellout"
SRC_URI="https://github.com/opscode/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

each_ruby_prepare() {
	# Make sure we actually use the right interpreter for testing
	sed -i -e "/ruby_eval/ s:ruby :${RUBY} :" spec/mixlib/shellout_spec.rb || die
}

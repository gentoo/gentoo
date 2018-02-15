# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

# There are no unit tests, only integration tests against a full Rails
# 3.2 application. Skipping those for now due to difficulty in getting
# all dependencies right.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRAINSTALL="app"

inherit ruby-fakegem

DESCRIPTION="A popular and flexible JavaScript DatePicker for RubyOnRails"
HOMEPAGE="https://github.com/timcharper/calendar_date_select"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rails-3.1:*"
